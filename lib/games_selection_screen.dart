import 'package:flutter/material.dart';

class GamesSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 41, 19, 76), // Dark purple color
        title: Text(
          'Games',
          style: TextStyle(
            color: Colors.white, // White color for title
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // White color for back arrow
        ),
      ),
      body: Container(
        color: Colors.white, // White background color for the entire screen
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select a game from the options',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 30), // Space between the title and buttons
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/memory_game');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 41, 19, 76), // Dark purple button
                  foregroundColor: Colors.white, // White text color
                  padding: EdgeInsets.symmetric(vertical: 15.0), // Reduced padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                ),
                icon: Icon(
                  Icons.memory, // Icon for the memory game
                  size: 30,
                ),
                label: Text(
                  'Match Game',
                  style: TextStyle(
                    fontSize: 18.0, // Reduced font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
              ),
              SizedBox(height: 20), // Space between buttons
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/memory_quiz_game');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 41, 19, 76), // Dark purple button
                  foregroundColor: Colors.white, // White text color
                  padding: EdgeInsets.symmetric(vertical: 15.0), // Reduced padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                ),
                icon: Icon(
                  Icons.quiz, // Icon for the quiz game
                  size: 30,
                ),
                label: Text(
                  'Quiz Game',
                  style: TextStyle(
                    fontSize: 18.0, // Reduced font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
              ),
              SizedBox(height: 50), // Space at the bottom for potential navbar
            ],
          ),
        ),
      ),
    );
  }
}
