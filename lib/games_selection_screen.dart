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
          child: SingleChildScrollView(
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
                
                _buildGameButton(
                  context,
                  Icons.memory,
                  'The first game is a classic memory matching card game. Users select images from their gallery, which are then used as the cards in the game. The objective is to match pairs of cards by flipping them over. If you make 3 or 4 incorrect matches, the game will briefly reveal two cards as a hint before flipping them back over. This feature helps players remember the card positions and improves their chances of making a correct match.',
                  'Match Game',
                  '/memory_game',
                ),
                SizedBox(height: 20), // Space between buttons

                _buildGameButton(
                  context,
                  Icons.quiz,
                  'The second game is a customizable quiz game. At the start, users can create a quiz by adding questions and answers, which are stored in Firebase. When you select the quiz game from the games page, the saved questions will appear. If needed, you can edit the quiz at any time through the settings page, and the updated questions will automatically be reflected in the game. During gameplay, if you make two incorrect attempts at answering a question, the correct answer will be revealed to assist you in learning and retaining the information.',
                  'Quiz Game',
                  '/memory_quiz_game',
                ),
                SizedBox(height: 50), // Space at the bottom for potential navbar
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameButton(
    BuildContext context,
    IconData icon,
    String description,
    String gameTitle,
    String routeName,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Card(
        color: Color.fromARGB(255, 41, 19, 76), // Dark purple color
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, routeName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 41, 19, 76), // Dark purple button
                  foregroundColor: Colors.white, // White text color
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                icon: Icon(
                  icon,
                  size: 30,
                ),
                label: Text(
                  gameTitle,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10), // Space between button and description
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
