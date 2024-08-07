import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  File? image;
  String questionText;
  List<String> options;
  bool imageValidationFailed;
  int correctAnswerIndex; // New field for correct answer

  Question({
    this.image,
    this.questionText = '',
    required this.options,
    this.imageValidationFailed = false,
    this.correctAnswerIndex = 0, // Default to first option
  });
}

class QuizFormPage extends StatefulWidget {
  @override
  _QuizFormPageState createState() => _QuizFormPageState();
}

class _QuizFormPageState extends State<QuizFormPage> {
  final _formKey = GlobalKey<FormState>();
  List<Question> questions = [Question(options: ['', '', ''])];
  final picker = ImagePicker();
  late final int timenow;  // Declare timenow inside the class

  _QuizFormPageState() {
    timenow = DateTime.now().millisecondsSinceEpoch;  // Initialize timenow when the state is created
  }

  Future getImage(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        questions[index].image = File(pickedFile.path);
        questions[index].imageValidationFailed = false;
      } else {
        print('No image selected.');
        questions[index].imageValidationFailed = true;
      }
    });
  }

  Future<String> uploadImage(File image) async {
    String uniqueFileName = timenow.toString() + '_' + image.path.split('/').last;
    String fileName = 'quiz_images/$timenow/$uniqueFileName';
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(fileName);

    try {
      await ref.putFile(image);
      String downloadURL = await ref.getDownloadURL();
      print("Upload successful: $downloadURL");
      return downloadURL;
    } on FirebaseException catch (e) {
      print("Upload failed: ${e.message}");
      return '';  // Handle the error appropriately
    }
  }

  Future<void> saveQuizDetails() async {
    bool allImagesPresent = true;

    // Check if all questions have images before attempting to upload any data
    for (var question in questions) {
      if (question.image == null) {
        question.imageValidationFailed = true;
        allImagesPresent = false;
      } else {
        question.imageValidationFailed = false;
      }
    }

    if (!allImagesPresent) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please add images for all questions.')));
      return; // Stop further execution if any image is missing
    }

    // Upload images and save data to Firestore
    for (var question in questions) {
      if (question.image != null) {
        String imageUrl = await uploadImage(question.image!);
        if (imageUrl.isNotEmpty) {
          var quizDetails = {
            'picture': imageUrl,
            'question': question.questionText,
            'options': question.options,
            'correctAnswerIndex': question.correctAnswerIndex, // Storing the index of the correct answer
          };
          try {
            await FirebaseFirestore.instance
                .collection('quiz_details')
                .doc(timenow.toString())
                .collection('questions')
                .add(quizDetails);
            print("Data saved successfully for ${question.questionText}");
          } catch (e) {
            print("Error saving data: $e");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving data: $e')));
          }
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quiz details saved successfully!')));
  }

  Widget buildQuestionCard(int index) {
    Question question = questions[index];
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => getImage(index),
              child: Container(
                width: 200, // Increased width
                height: 200, // Increased height
                decoration: BoxDecoration(
                  color: question.image != null ? Colors.grey[200] : (question.imageValidationFailed ? Colors.red[200] : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: question.imageValidationFailed ? Colors.red : Colors.grey,
                    width: 2,
                  ),
                ),
                child: question.image != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(question.image!, fit: BoxFit.cover), // Changed to BoxFit.cover for better aspect ratio handling
                )
                    : Icon(Icons.camera_alt, color: Colors.grey[800]),
              ),
            ),
            if (question.imageValidationFailed)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Image is required',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            TextFormField(
              initialValue: question.questionText,
              onChanged: (value) => question.questionText = value,
              decoration: InputDecoration(labelText: 'Enter your question'),
            ),
            ...List.generate(question.options.length, (optionIndex) => ListTile(
              title: TextFormField(
                initialValue: question.options[optionIndex],
                onChanged: (value) {
                  setState(() {
                    question.options[optionIndex] = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Option ${optionIndex + 1}'),
              ),
              trailing: IconButton(
                icon: Icon(
                  question.correctAnswerIndex == optionIndex ? Icons.check_circle : Icons.check_circle_outline,
                  color: question.correctAnswerIndex == optionIndex ? Colors.green : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    question.correctAnswerIndex = optionIndex;
                  });
                },
              ),
            )),
            if (questions.length > 1)
              IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: () => setState(() => questions.removeAt(index)),
              )
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quiz'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ...questions.map((question) => buildQuestionCard(questions.indexOf(question))).toList(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    questions.add(Question(options: ['', '', '']));
                  });
                },
                child: Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await saveQuizDetails();
                    }
                  },
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}