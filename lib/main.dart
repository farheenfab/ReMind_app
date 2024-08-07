import 'package:alz_app/quiz_form_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'welcome_screen.dart';
import 'settings.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'memory_game.dart';
import 'memory_quiz_game.dart';
import 'quiz_form_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ReMind',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
          ).copyWith(secondary: Colors.white),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        initialRoute: '/welcome',
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          // '/login': (context) => GamesSelectionScreen(),
          '/memory_game': (context) => MemoryGameHome(),
          '/memory_quiz_game': (context) => MemoryQuizGame(),
          '/quiz_form_page': (context) => QuizFormPage(),
          '/settings': (context) => SettingsPage(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/home': (context) => const HomePage(username: 'John'),
        });
  }
}
