import 'package:flutter/material.dart';
import 'bottom_navigation.dart'; // Import the custom navigation bar
import 'home_page.dart';
import 'settings.dart';
import 'games_page.dart';
import 'games_selection_screen.dart';
import 'journal.dart';
import 'journal_content.dart';
import 'journal_listview.dart';

class MemoryLogPage extends StatefulWidget {
  @override
  _MemoryLogPageState createState() => _MemoryLogPageState();
}

class _MemoryLogPageState extends State<MemoryLogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                  backgroundColor: Color.fromARGB(255, 41, 19, 76), // Dark Purple background color for AppBar
        title: Text('Memory'),
      ),
      body: Center(
        child: Text('This is the Memory Log Page'),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          // Define your navigation logic here
          if (index != 2) {
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
                      return MemoryLogPage();
                    case 3:
                      return SettingsPage();
                    default:
                      return MemoryLogPage();
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
