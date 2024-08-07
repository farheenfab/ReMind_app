import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'welcome_screen.dart';
import 'quiz_form_page.dart';  // Ensure this is correctly imported

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool hasQuiz = false;  // State to track if a quiz exists

  @override
  void initState() {
    super.initState();
    checkForQuiz();
  }

  Future<void> checkForQuiz() async {
    // Collection Group query across all 'questions' subcollections in the database
    var querySnapshot = await FirebaseFirestore.instance.collectionGroup('questions').limit(1).get();
    print(querySnapshot.docs);

    if (querySnapshot.docs.isNotEmpty) {
      print("Quiz exists: Found questions.");
      setState(() {
        hasQuiz = true;
      });
    } else {
      print("No quizzes found.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          const SettingsTile(
            icon: Icons.info,
            title: 'About',
          ),
          const Divider(color: Colors.black),
          const SettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
          ),
          const Divider(color: Colors.black),
          const SettingsTile(
            icon: Icons.mic,
            title: 'Microphone Voice Settings',
          ),
          const Divider(color: Colors.black),
          const SettingsTile(
            icon: Icons.lock,
            title: 'Privacy and Security',
          ),
          const Divider(color: Colors.black),
          SettingsTile(
            icon: hasQuiz ? Icons.edit : Icons.add,
            title: hasQuiz ? 'Edit Quiz' : 'Create Quiz',
            onTap: () {
              // Navigate to QuizFormPage or QuizEditPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizFormPage()), // Adjust if there's a specific edit page
              );
            },
          ),
          const Divider(color: Colors.black),
          SettingsTile(
            icon: Icons.exit_to_app,
            title: 'Log Out',
            onTap: () => _showLogoutDialog(context),
          ),
          const Divider(color: Colors.black),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Are you sure you want to log out?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, '/welcome');
                    },
                  ),
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
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
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}