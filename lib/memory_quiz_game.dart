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
      var latestDatetimeSnapshot = await firestore.collection('quiz_details')
          .orderBy('datetime', descending: true)
          .limit(1)
          .get();

      if (latestDatetimeSnapshot.docs.isEmpty) {
        print("No quiz entries found.");
        setState(() => _isLoading = false);
        return;
      }

      int latestDatetime = latestDatetimeSnapshot.docs.first.data()['datetime'] as int;
      print("Latest datetime: $latestDatetime");

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
    _confettiController.play(); // Start confetti when the dialog is shown
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white, // White background for the dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          contentPadding: EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Congratulations!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color.fromARGB(255, 41, 19, 76),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'You have completed the quiz.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _resetGame();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 41, 19, 76), // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Rounded corners
                      ),
                    ),
                    child: Text(
                      'Play Again',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/games_selection');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 41, 19, 76), // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Rounded corners
                      ),
                    ),
                    child: Text(
                      'Go Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _questions.clear();
      _currentQuestionIndex = 0;
      _wrongGuesses = 0;
      _wrongAnswers.clear();
      _isLoading = true;
    });
    fetchLatestQuizItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 41, 19, 76),
        title: Text(
          'Memory Quiz Game',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        color: Colors.white, // White background color for the entire screen
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Stack(
                alignment: Alignment.center,
                children: [
                  if (_questions.isNotEmpty) ...[
                    Center(
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CachedNetworkImage(
                                imageUrl: _questions[_currentQuestionIndex].imageUrl,
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                imageBuilder: (context, imageProvider) => Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                _questions[_currentQuestionIndex].questionText,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              SizedBox(height: 20),
                              Column(
                                children: _questions[_currentQuestionIndex].options.map((option) {
                                  int idx = _questions[_currentQuestionIndex].options.indexOf(option);
                                  bool isWrong = _wrongAnswers.contains(idx);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () => _onOptionSelected(idx),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isWrong ? Colors.red[300] : Color.fromARGB(255, 41, 19, 76), // Button color
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                          ),
                                        ),
                                        child: Text(
                                          option,
                                          style: TextStyle(
                                            color: isWrong ? Colors.white : Color.fromARGB(255, 255, 255, 255),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirection: -3.14 / 2, // Top direction
                      particleDrag: 0.05,
                      emissionFrequency: 0.05,
                      numberOfParticles: 50,
                      gravity: 0.05,
                      shouldLoop: false,
                      colors: const [
                        Color.fromARGB(255, 163, 215, 165),
                        Color.fromARGB(255, 145, 183, 215),
                        Color.fromARGB(255, 211, 143, 166),
                        Color.fromARGB(255, 201, 177, 140),
                        Color.fromARGB(255, 178, 136, 185),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
