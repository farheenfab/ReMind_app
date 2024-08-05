import 'package:flutter/material.dart';
import 'bottom_navigation.dart'; // Import the custom navigation bar
import 'home_page.dart';
import 'settings.dart';
import 'games_page.dart';
import 'memory_log_page.dart';

class GamesPage extends StatefulWidget {
  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games'),
      ),
      body: Center(
        child: Text('This is the Games Page'),
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
                      return HomePage(
                          username:
                              'User'); // Replace 'User' with actual username if needed
                    case 1:
                      return GamesPage();
                    case 2:
                      return MemoryLogPage();
                    case 3:
                      return SettingsPage();
                    default:
                      return GamesPage();
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
