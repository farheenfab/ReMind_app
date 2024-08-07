import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'gemini_service.dart';

class MemoryQuizGame extends StatefulWidget {
  @override
  _MemoryQuizGameState createState() => _MemoryQuizGameState();
}

class _MemoryQuizGameState extends State<MemoryQuizGame> {
  List<XFile> _images = [];
  int _currentImageIndex = 0;
  int _wrongGuesses = 0;
  List<String> _options = [];
  String _correctOption = '';
  final ImagePicker _picker = ImagePicker();
  final GeminiService _geminiService = GeminiService();

  @override
  void initState() {
    super.initState();
    _selectImages();
  }

  Future<void> _selectImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _images = images.length > 10 ? images.sublist(0, 10) : images;
        _loadQuestion();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select at least 1 image.'),
      ));
      Navigator.pop(context);
    }
  }

  Future<void> _loadQuestion() async {
    if (_currentImageIndex < _images.length) {
      print("hello");
      File imageFile = File(_images[_currentImageIndex].path);
      String prompt = 'Generate four multiple-choice questions (very short description) based on this image for a memory quiz game for an Alzheimer patient. Each question should have one correct answer and three incorrect answers. The incorrect answers should be related but clearly distinguishable from the correct answer.';
      final response = await _geminiService.getMCQOptions(imageFile, prompt);
      print(response);
      // Assuming the response contains 'options' and 'correct_option' keys
      setState(() {
        _options = List<String>.from(response['options']);
        _correctOption = response['correct_option'];
      });
      // try {
      //   print("hello");
      //   File imageFile = File(_images[_currentImageIndex].path);
      //   String prompt = 'Generate four multiple-choice questions (very short description) based on this image for a memory quiz game for an Alzheimer patient. Each question should have one correct answer and three incorrect answers. The incorrect answers should be related but clearly distinguishable from the correct answer.';
      //   final response = await _geminiService.getMCQOptions(imageFile, prompt);
      //   print(response);
      //   // Assuming the response contains 'options' and 'correct_option' keys
      //   setState(() {
      //     _options = List<String>.from(response['options']);
      //     _correctOption = response['correct_option'];
      //   });
      // } catch (e) {
      //   print(e);
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text('Failed to load options: $e'),
      //   ));
      // }
    } else {
      _showCompletionDialog();
    }
  }

  void _onOptionSelected(String option) {
    if (option == _correctOption) {
      _currentImageIndex++;
      _wrongGuesses = 0;
      _loadQuestion();
    } else {
      setState(() {
        _wrongGuesses++;
      });
      if (_wrongGuesses >= 3) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Hint: The correct answer is $_correctOption'),
        ));
      }
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
              Navigator.of(context).pop();
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
      ),
      body: _images.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(File(_images[_currentImageIndex].path)),
          SizedBox(height: 20),
          ..._options.map((option) => ElevatedButton(
            onPressed: () => _onOptionSelected(option),
            child: Text(option),
          )),
        ],
      ),
    );
  }
}
