import 'package:flutter/material.dart';
import 'microphone_settings.dart'; // Import the new MicrophoneSettingsPage

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // Black color for the title text
          ),
        ),
        backgroundColor: Colors.white, // White background for the AppBar
        iconTheme: IconThemeData(
          color: Color(0xFF382973), // Dark purple color for the AppBar icons
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
            const SettingsTile(
              icon: Icons.info,
              title: 'About',
            ),
            const Divider(color: Colors.black),
            const SizedBox(height: 16.0),
            SettingsTile(
              icon: Icons.mic,
              title: 'Microphone Voice Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MicrophoneSettingsPage()),
                );
              },
            ),
            const Divider(color: Colors.black),
            const SizedBox(height: 16.0),
            const SettingsTile(
              icon: Icons.lock,
              title: 'Privacy and Security',
            ),
            const Divider(color: Colors.black),
            const SizedBox(height: 16.0),
            SettingsTile(
              icon: Icons.exit_to_app,
              title: 'Log Out',
              onTap: () => _showLogoutDialog(context),
            ),
            const Divider(color: Colors.black),
          ],
        ),
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
              const Text(
                'Are you sure you want to log out?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Bold text
                  fontSize: 17.0, // Increased text size
                  color: Colors.black, // Text color
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text(
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
              Divider(
                color: Colors.black, // Divider color
              ),
              TextButton(
                child: const Text(
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
        color: Color(0xFF382973), // Dark purple color for the icon
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black, // Black color for the text
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Color(0xFF382973), // Dark purple color for the arrow icon
      ),
      onTap: onTap,
    );
  }
}
