import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_page.dart';
import 'settings.dart';
import 'games_page.dart';
import 'memory_log_page.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.games),
          label: 'Games',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.brain),
          label: 'Memory Log',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Color.fromARGB(255, 255, 255, 255),
      unselectedItemColor: Color.fromARGB(255, 206, 188, 255),
      onTap: onTap,
      backgroundColor: const Color.fromARGB(255, 41, 19, 76),
    );
  }
}
