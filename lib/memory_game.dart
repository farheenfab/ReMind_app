import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';

class MemoryGameHome extends StatefulWidget {
  @override
  _MemoryGameHomeState createState() => _MemoryGameHomeState();
}

class _MemoryGameHomeState extends State<MemoryGameHome> {
  List<XFile> _images = [];
  List<int> _selectedIndexes = [];
  List<bool> _matched = [];
  bool _isSelectingImages = true;
  final ImagePicker _picker = ImagePicker();
  int _failedAttempts = 0;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _selectImages();
    _confettiController = ConfettiController(duration: const Duration(seconds: 10));
  }

  Future<void> _selectImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.length == 4) {
      setState(() {
        _images = List.from(images); // Ensure only 4 images are taken
        _images.addAll(List.from(_images)); // Duplicate images to create pairs
        _images.shuffle(); // Shuffle images
        _matched = List<bool>.filled(_images.length, false);
        _isSelectingImages = false;
      });
    } else {
      // Show message to select exactly 4 images
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select exactly 4 images.'),
      ));
      _selectImages();
    }
  }

  void _onCardTapped(int index) {
    if (_selectedIndexes.length == 2 || _matched[index] || _selectedIndexes.contains(index)) return;

    setState(() {
      _selectedIndexes.add(index);
    });

    if (_selectedIndexes.length == 2) {
      if (_images[_selectedIndexes[0]].path == _images[_selectedIndexes[1]].path) {
        setState(() {
          _matched[_selectedIndexes[0]] = true;
          _matched[_selectedIndexes[1]] = true;
          _selectedIndexes.clear();
          if (_matched.every((element) => element)) {
            _confettiController.play();
            _showCompletionDialog();
          }
        });
      } else {
        setState(() {
          _failedAttempts++;
        });
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _selectedIndexes.clear();
          });
        });
        if (_failedAttempts >= 4) {
          _showHint();
        }
      }
    }
  }

  void _showHint() {
    int hintIndex = _matched.indexOf(false);
    setState(() {
      _selectedIndexes.add(hintIndex);
      _selectedIndexes.add(_images.indexWhere((image) => image.path == _images[hintIndex].path && !_selectedIndexes.contains(image)));
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _selectedIndexes.clear();
      });
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Congratulations!'),
        content: Text('You have matched all the pictures.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: Text('Play Again'),
          ),
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

  void _resetGame() {
    setState(() {
      _images.clear();
      _selectedIndexes.clear();
      _matched.clear();
      _failedAttempts = 0;
      _isSelectingImages = true;
    });
    _selectImages();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          _isSelectingImages
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
            padding: EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Adjusted for 4 images in pairs
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: _images.length,
            itemBuilder: (context, index) {
              bool isSelected = _selectedIndexes.contains(index) || _matched[index];
              return GestureDetector(
                onTap: () => _onCardTapped(index),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[200],
                      borderRadius: BorderRadius.circular(15.0),
                      image: isSelected
                          ? DecorationImage(
                        image: FileImage(File(_images[index].path)),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: isSelected
                        ? null
                        : Center(
                      child: Image.asset('lib/assets/logo.png', width: 100, height: 100),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
