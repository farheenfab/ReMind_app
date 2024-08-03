import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:alz_app/Screen/sos.dart';
import 'package:flutter/foundation.dart';
import 'package:alz_app/Screen/medicineAdd.dart';
// import 'package:alz_app/Screen/notification.dart';
import 'package:alz_app/Screen/medicineView.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
//   await Firebase.initializeApp(
//    options: DefaultFirebaseOptions.currentPlatform,
//  );

  // await NotificationService().init();

  await FirebaseMessaging.instance.subscribeToTopic("topic");
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $fcmToken");

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alzheimer\'s App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
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
                navigateToMedicineView(context);  // Add navigation to MedicineViewPage
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


