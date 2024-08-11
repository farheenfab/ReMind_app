import 'package:flutter/material.dart';
import 'bottom_navigation.dart';
import 'home_page.dart';
import 'settings.dart';
import 'journal_listview.dart';

class GamesSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 41, 19, 76), // Dark purple color
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
        child: SingleChildScrollView(
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

              // Match Game Section
              Text(
                'Users select 4 images from their gallery, which are used as the cards in the game. Aim is to match pairs of cards by flipping them over. When 3 or 4 incorrect matches are made, the game will briefly reveal two cards as a hint before flipping them back over.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 10), // Space between the description and button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/memory_game');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 41, 19, 76), // Dark purple button
                  foregroundColor: Colors.white, // White text color
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0), // Reduced padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                ),
                icon: Icon(
                  Icons.memory, // Icon for the memory game
                  size: 30,
                ),
                label: Text(
                  'Play Match Game',
                  style: TextStyle(
                    fontSize: 18.0, // Reduced font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
              ),

              SizedBox(height: 20), // Space between sections

              // Quiz Game Section
              Text(
                'This is a customizable quiz game. Users can create a quiz by adding questions and answers, which are stored in Firebase. When you select the quiz game from the games page, the saved questions will appear. If needed, you can edit the quiz at any time through settings. During gameplay, if you make two incorrect attempts, the correct answer will be revealed to assist you.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 10), // Space between the description and button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/memory_quiz_game');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 41, 19, 76), // Dark purple button
                  foregroundColor: Colors.white, // White text color
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0), // Reduced padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                ),
                icon: Icon(
                  Icons.quiz, // Icon for the quiz game
                  size: 30,
                ),
                label: Text(
                  'Play Quiz Game',
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          // Define your navigation logic here
          if (index != 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  switch (index) {
                    case 0:
                      return HomePage(); // Replace 'User' with actual username if needed
                    case 1:
                      return GamesSelectionScreen();
                    case 2:
                      return DisplayData();
                    case 3:
                      return SettingsPage();
                    default:
                      return SettingsPage();
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
