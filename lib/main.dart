import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'journal.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'messages.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'voice_settings.dart';
import 'database.dart';
import 'journal_listview.dart';
import 'calanderEvent.dart';
import 'splash_screen.dart';
import 'welcome_screen.dart';
import 'settings.dart';
import 'login_page.dart';
import 'signup_page.dart';
import '/Screen/sos.dart';
import 'package:flutter/foundation.dart';
import 'package:alz_app/Screen/medicineAdd.dart';
// import 'package:alz_app/Screen/notification.dart';
import 'package:alz_app/Screen/medicineView.dart';
import 'calanderEvent.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'memory_game.dart';
import 'memory_quiz_game.dart';
import 'quiz_form_page.dart';
import 'games_selection_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
//   await Firebase.initializeApp(
//    options: DefaultFirebaseOptions.currentPlatform,
//  );

  // await NotificationService().init();

  await FirebaseMessaging.instance.subscribeToTopic("topic");
  final fcmToken = await FirebaseMessaging.instance.getToken();
  // print("FCM Token: $fcmToken");
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReMind',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 41, 19, 76),
          secondary: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/settings': (context) => SettingsPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/games_selection': (context) => GamesSelectionScreen(),
        '/memory_game': (context) => MemoryGameHome(),
        '/memory_quiz_game': (context) => MemoryQuizGame(),
        '/quiz_form_page': (context) => QuizFormPage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                navigateToSOS(context);
              },
              child: const Text('Go to SOS Page'),
            ),
            ElevatedButton(
              onPressed: () {
                navigateToMedicineReminder(context);
              },
              child: const Text('Medicine Reminder'),
            ),
            ElevatedButton(
              onPressed: () {
                navigateToMedicineView(
                    context); // Add navigation to MedicineViewPage
              },
              child: const Text('View Medicines'),
            ),
          ],
        ),
      ),
    );
  }
}

void navigateToSOS(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const SOSPage(),
    ),
  );
}

void navigateToMedicineReminder(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => AddMedicineScreen(),
    ),
  );
}

void navigateToMedicineView(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => MedicineViewPage(),
    ),
  );
}
