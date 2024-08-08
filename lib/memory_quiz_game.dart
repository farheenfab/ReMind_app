import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Question {
  String imageUrl;
  String questionText;
  List<String> options;
  int correctAnswerIndex;

  Question({
    required this.imageUrl,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class MemoryQuizGame extends StatefulWidget {
  @override
  _MemoryQuizGameState createState() => _MemoryQuizGameState();
}

class _MemoryQuizGameState extends State<MemoryQuizGame> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _wrongGuesses = 0;
  bool _isLoading = true;
  late ConfettiController _confettiController;
  Set<int> _wrongAnswers = {};

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 10));
    fetchLatestQuizItems();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> fetchLatestQuizItems() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      // First, find the latest datetime value
      var latestDatetimeSnapshot = await firestore.collection('quiz_details')
          .orderBy('datetime', descending: true)
          .limit(1)
          .get();

      if (latestDatetimeSnapshot.docs.isEmpty) {
        print("No quiz entries found.");
        setState(() => _isLoading = false);
        return;
      }

      // Extract the latest datetime
      int latestDatetime = latestDatetimeSnapshot.docs.first.data()['datetime'] as int;
      print("Latest datetime: $latestDatetime");

      // Fetch all documents with the latest datetime
      QuerySnapshot questionSnapshot = await firestore
          .collection('quiz_details')
          .where('datetime', isEqualTo: latestDatetime)
          .get();

      if (questionSnapshot.docs.isEmpty) {
        print("No questions found with the latest datetime.");
        setState(() => _isLoading = false);
        return;
      }

      setState(() {
        _questions = questionSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          print("Loaded question data: $data");
          return Question(
            imageUrl: data['picture'] as String,
            questionText: data['question'] as String,
            options: List<String>.from(data['options']),
            correctAnswerIndex: data['correctAnswerIndex'] as int,
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching quiz details: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onOptionSelected(int selectedIndex) {
    if (selectedIndex == _questions[_currentQuestionIndex].correctAnswerIndex) {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _wrongGuesses = 0;
          _wrongAnswers.clear();
        });
      } else {
        _showCompletionDialog();
        _confettiController.play();
      }
    } else {
      setState(() {
        _wrongGuesses++;
        _wrongAnswers.add(selectedIndex);
        if (_wrongGuesses >= 2) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Hint: The correct answer is ${_questions[_currentQuestionIndex].options[_questions[_currentQuestionIndex].correctAnswerIndex]}'),
          ));
        }
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Congratulations!'),
        content: Text('You have completed the quiz.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/games_selection');
            },
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Quiz Game'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Center( // Center the column
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_questions.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: _questions[_currentQuestionIndex].imageUrl,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _questions[_currentQuestionIndex].questionText,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                          ),
                        ),
                        Column( // Display options in a column
                          children: _questions[_currentQuestionIndex].options.map((option) {
                            int idx = _questions[_currentQuestionIndex].options.indexOf(option);
                            bool isWrong = _wrongAnswers.contains(idx);
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ChoiceChip(
                                label: Text(option),
                                selected: false,
                                onSelected: (_) => _onOptionSelected(idx),
                                backgroundColor: isWrong ? Colors.red[200] : Colors.deepPurple[50],
                                selectedColor: Colors.deepPurple[300],
                                labelStyle: TextStyle(color: isWrong ? Colors.white : Colors.deepPurple[900]),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    particleDrag: 0.05,
                    emissionFrequency: 0.05,
                    numberOfParticles: 50,
                    gravity: 0.05,
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}