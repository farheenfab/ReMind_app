import 'dart:async';
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
  late final int newTimeNow;

  @override
  void initState() {
    super.initState();
    newTimeNow = DateTime.now().millisecondsSinceEpoch;
    if (widget.latestDateTime != null) {
      fetchQuizDetails(widget.latestDateTime!);
    } else {
      questions = [Question(options: ['', '', ''])];
    }
  }

  Future<void> fetchQuizDetails(String latestDateTime) async {
    var quizCollection = FirebaseFirestore.instance.collection('quiz_details');
    var snapshot = await quizCollection.where('datetime', isEqualTo: int.parse(latestDateTime)).get();
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
    String uniqueFileName = newTimeNow.toString() + '_' + image.path.split('/').last;
    String fileName = 'quiz_images/$uniqueFileName';
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(fileName);
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<void> saveQuizDetails() async {
    setState(() {
      _isSaving = true;
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
      await FirebaseFirestore.instance.collection('quiz_details').add(quizDetails);
    }

    setState(() {
      _isSaving = false;
      _showSuccess = true;
    });

    // Show success screen for 2 seconds
    await Future.delayed(Duration(seconds: 2));
    setState(() => _showSuccess = false);
    Navigator.of(context).pop();
  }

  Widget buildQuestionCard(int index) {
    Question question = questions[index];
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => getImage(index),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: question.image != null ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(question.image!, fit: BoxFit.fill),
                ) : question.imageUrl.isNotEmpty ? Image.network(question.imageUrl, fit: BoxFit.fill) : Icon(Icons.camera_alt, color: Colors.grey[800]),
              ),
            ),
            TextFormField(
              initialValue: question.questionText,
              onChanged: (value) => setState(() => question.questionText = value),
              decoration: InputDecoration(labelText: 'Enter your question'),
            ),
            ...List.generate(question.options.length, (optionIndex) => ListTile(
              title: TextFormField(
                initialValue: question.options[optionIndex],
                onChanged: (value) => setState(() => question.options[optionIndex] = value),
                decoration: InputDecoration(labelText: 'Option ${optionIndex + 1}'),
              ),
              trailing: IconButton(
                icon: Icon(question.correctAnswerIndex == optionIndex ? Icons.check_circle : Icons.check_circle_outline,
                    color: question.correctAnswerIndex == optionIndex ? Colors.green : Colors.grey),
                onPressed: () => setState(() => question.correctAnswerIndex = optionIndex),
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
        title: Text(widget.latestDateTime == null ? 'Create Quiz' : 'Edit Quiz'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...questions.map((question) => buildQuestionCard(questions.indexOf(question))).toList(),
              if (questions.isEmpty)
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Tap '+' to add a question.", style: TextStyle(fontSize: 16)),
                ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && questions.isNotEmpty) {
                    saveQuizDetails();
                  }
                },
                child: _isSaving ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : (_showSuccess ? Icon(Icons.check, color: Colors.white) : Text('Save')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _showSuccess ? Colors.green : Colors.blue,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
