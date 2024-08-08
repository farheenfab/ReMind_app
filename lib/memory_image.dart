import 'package:flutter/material.dart';
import 'bottom_navigation.dart'; // Import the custom navigation bar
import 'home_page.dart';
import 'settings.dart';
import 'games_page.dart';
import 'memory_log_page.dart';

class MemoryPage extends StatefulWidget {
  @override
  _MemoryPageState createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 41, 19, 76), // White background color for AppBar
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)), // Black color for back arrow
        title: Text(
          'Farheen',
          style: TextStyle(color: Colors.white), // Black color for title
        ),
      ),
      backgroundColor: Colors.white, // White background color for the whole screen
      body: Center(
        child: Text('Farheen Page'),
      ),
    );
  }
}
