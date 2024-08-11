import 'package:alz_app/voice_settings.dart';
import 'package:flutter/material.dart';
import 'voice_settings.dart'; // Import the new MicrophoneSettingsPage
import 'bottom_navigation.dart'; // Import the custom navigation bar
import 'home_page.dart';
import 'games_selection_screen.dart';
import 'settings.dart';
import 'games_page.dart';
import 'quiz_form_page.dart'; // Ensure this is correctly imported
import 'memory_log_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firebase
import 'journal.dart';
import 'journal_content.dart';
import 'journal_listview.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool hasQuiz = false; // State to track if a quiz exists
  String latestDateTime = '';

  @override
  void initState() {
    super.initState();
    checkForQuiz();
    fetchLatestQuizDateTime();
  }

  Future<void> fetchLatestQuizDateTime() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('quiz_details')
        .orderBy('datetime', descending: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        latestDateTime = snapshot.docs.first.data()['datetime'].toString();
      });
    }
  }

  Future<void> checkForQuiz() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('quiz_details')
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        hasQuiz = true;
      });
    } else {
      setState(() {
        hasQuiz = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // White color for the title text
          ),
        ),
        backgroundColor:
            const Color.fromARGB(255, 41, 19, 76), // Dark Purple background color for AppBar
        iconTheme: IconThemeData(
          color: Colors.white, // White color for the AppBar icons
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.black, // Color of the divider
            height: 1.0, // Height of the divider
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // Background color for the entire page
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: SettingsTile(
                icon: Icons.info,
                title: 'About',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white, // White background color
                        title: Text(
                          'About Remind',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Bold title
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                'ReMind is your companion designed to support individuals with Alzheimer\'s and their caregivers. Our app offers a suite of features to help manage daily tasks, medication, communication, and cognitive health.',
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Divider(color: Colors.black),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: SettingsTile(
                icon: Icons.mic,
                title: 'Voice Over Settings',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoiceSettings(),
                    ),
                  );
                },
              ),
            ),
            Divider(color: Colors.black),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: SettingsTile(
                icon: Icons.lock,
                title: 'Privacy and Security',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white, // White background color
                        title: Text(
                          'Privacy and Security',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Bold title
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                'Your privacy and security are our top priorities. We ensure that all data collected through the Remind app is securely stored and protected. We adhere to strict data protection regulations and only use your data to enhance your experience and provide support. For detailed information on how we handle your data, please refer to our Privacy Policy and Terms of Service available in the app.',
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Data Protection: All personal information is encrypted and securely stored.',
                              ),
                              Text(
                                'Third-Party Services: We do not share your data with third parties without your consent.',
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(color: Colors.black),
            SettingsTile(
              icon: hasQuiz ? Icons.edit : Icons.add,
              title: hasQuiz ? 'Edit Quiz' : 'Create Quiz',
              onTap: () {
                // Navigate to QuizFormPage or QuizEditPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuizFormPage(
                          latestDateTime:
                              latestDateTime)), // Adjust if there's a specific edit page
                );
              },
            ),
            const Divider(color: Colors.black),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: SettingsTile(
                icon: Icons.exit_to_app,
                title: 'Log Out',
                onTap: () => _showLogoutDialog(context),
              ),
            ),
            Divider(color: Colors.black),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          // Define your navigation logic here
          if (index != 3) {
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Color(0xFFD3D3D3), // Pastel grey color for background
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to log out?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Bold text
                  fontSize: 17.0, // Increased text size
                  color: Colors.black, // Text color
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0, // Bold text
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/welcome');
                },
              ),
              Divider(color: Colors.black), // Divider color
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0, // Bold text
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const SettingsTile({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Color.fromARGB(255, 41, 19, 76),
        size: 32.0, // Dark purple color for the icon
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black, // Black color for the text
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Color.fromARGB(
            255, 41, 19, 76), // Dark purple color for the arrow icon
      ),
      onTap: onTap,
    );
  }
}
