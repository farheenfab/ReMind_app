import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';

class Question {
  File? image;
  String questionText;
  List<String> options;
  bool imageValidationFailed;
  int correctAnswerIndex;
  String imageUrl;

  Question({
    this.image,
    this.questionText = '',
    required this.options,
    this.imageValidationFailed = false,
    this.correctAnswerIndex = 0,
    this.imageUrl = '',
  });
}

class QuizFormPage extends StatefulWidget {
  final String? latestDateTime;

  QuizFormPage({this.latestDateTime});

  @override
  _QuizFormPageState createState() => _QuizFormPageState();
}

class _QuizFormPageState extends State<QuizFormPage> {
  final _formKey = GlobalKey<FormState>();
  List<Question> questions = [];
  final picker = ImagePicker();
  bool _isSaving = false;
  bool _showSuccess = false;
  bool _showLoading = false;
  late final int newTimeNow;

  @override
  void initState() {
    super.initState();
    newTimeNow = DateTime.now().millisecondsSinceEpoch;
    if (widget.latestDateTime != null) {
      fetchQuizDetails(widget.latestDateTime!);
    } else {
      questions = [
        Question(options: ['', '', ''])
      ];
    }
  }

  Future<void> fetchQuizDetails(String latestDateTime) async {
    var quizCollection = FirebaseFirestore.instance.collection('quiz_details');
    var snapshot = await quizCollection
        .where('datetime', isEqualTo: int.parse(latestDateTime))
        .get();
    var quizDocs = snapshot.docs;
    if (quizDocs.isNotEmpty) {
      setState(() {
        questions = quizDocs.map((doc) {
          var data = doc.data();
          return Question(
            questionText: data['question'],
            options: List<String>.from(data['options']),
            correctAnswerIndex: data['correctAnswerIndex'],
            imageUrl: data['picture'],
          );
        }).toList();
      });
    }
  }

  Future getImage(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        questions[index].image = File(pickedFile.path);
        questions[index].imageValidationFailed = false;
      } else {
        questions[index].imageValidationFailed = true;
      }
    });
  }

  Future<String> uploadImage(File image) async {
    String uniqueFileName =
        newTimeNow.toString() + '_' + image.path.split('/').last;
    String fileName = 'quiz_images/$uniqueFileName';
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(fileName);
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<void> saveQuizDetails() async {
    setState(() {
      _isSaving = true;
      _showLoading = true;
    });
    for (var question in questions) {
      if (question.image != null && !question.imageValidationFailed) {
        question.imageUrl = await uploadImage(question.image!);
      }
      var quizDetails = {
        'datetime': newTimeNow,
        'picture': question.imageUrl,
        'question': question.questionText,
        'options': question.options,
        'correctAnswerIndex': question.correctAnswerIndex,
      };
      await FirebaseFirestore.instance
          .collection('quiz_details')
          .add(quizDetails);
    }

    // Show success screen after loading
    await Future.delayed(Duration(seconds: 1)); // Adjust delay as needed

    setState(() {
      _showLoading = false;
      _showSuccess = true;
    });

    // Wait for the success screen to be visible
    await Future.delayed(Duration(seconds: 2)); // Adjust delay as needed

    setState(() {
      _showSuccess = false;
    });

    // Navigate to home page
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  Widget buildQuestionCard(int index) {
    Question question = questions[index];
    return Card(
      margin: EdgeInsets.all(10),
      color: Colors.grey[300], // Set the card's background to grey
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => getImage(index),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: question.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(question.image!, fit: BoxFit.fill),
                      )
                    : question.imageUrl.isNotEmpty
                        ? Image.network(question.imageUrl, fit: BoxFit.fill)
                        : Icon(Icons.camera_alt, color: Colors.grey[800]),
              ),
            ),
            TextFormField(
              initialValue: question.questionText,
              onChanged: (value) =>
                  setState(() => question.questionText = value),
              decoration: InputDecoration(labelText: 'Enter your question'),
            ),
            ...List.generate(
                question.options.length,
                (optionIndex) => ListTile(
                      title: TextFormField(
                        initialValue: question.options[optionIndex],
                        onChanged: (value) => setState(
                            () => question.options[optionIndex] = value),
                        decoration: InputDecoration(
                            labelText: 'Option ${optionIndex + 1}'),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                            question.correctAnswerIndex == optionIndex
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: question.correctAnswerIndex == optionIndex
                                ? Colors.green
                                : Colors.grey),
                        onPressed: () => setState(
                            () => question.correctAnswerIndex = optionIndex),
                      ),
                    )),
            if (questions.length > 1)
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: () => setState(() {
                  questions.removeAt(index);
                }),
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
        backgroundColor:
            const Color.fromARGB(255, 41, 19, 76), // Dark purple AppBar
        title: Text(
          widget.latestDateTime == null ? 'Create Quiz' : 'Edit Quiz',
          style: TextStyle(color: Colors.white), // White title
        ),
        iconTheme: IconThemeData(color: Colors.white), // White back arrow
      ),
      body: Container(
        color:
            Color.fromARGB(255, 153, 153, 201), // Light purple background color
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...questions
                        .map((question) =>
                            buildQuestionCard(questions.indexOf(question)))
                        .toList(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    questions
                                        .add(Question(options: ['', '', '']));
                                  });
                                },
                                child: Text('Add'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await saveQuizDetails();
                                  }
                                },
                                child: Text('Save'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_showLoading || _showSuccess)
              AnimatedOpacity(
                opacity: _showLoading || _showSuccess ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Container(
                  color: Colors.green,
                  child: Center(
                    child: _showLoading
                        ? CircularProgressIndicator()
                        : _showSuccess
                            ? Icon(Icons.check_circle,
                                color: Colors.white, size: 100)
                            : Container(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
