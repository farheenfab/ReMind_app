// import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart';

class PostLoginWelcomePage extends StatelessWidget {
  const PostLoginWelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      backgroundColor: const Color.fromARGB(255, 41, 19, 76),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to ReMind',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'This app helps you manage and track details related to Alzheimer\'s care. You can log patient details, medication, and more.',
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => const HomePage(username: 'John')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 41, 19, 76),
              ),
              child: const Text('Let\'s Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
