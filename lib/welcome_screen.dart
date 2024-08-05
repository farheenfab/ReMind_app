import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'settings.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('lib/assets/logo.png', height: 100),
            const SizedBox(height: 20),
            const Text(
              'WELCOME TO ReMind',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Introduction on the app and maybe a scrollable view of the main features of the app with an image.',
              style:
                  TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF382973),
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: const Text('Log In'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/signup');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF382973),
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
