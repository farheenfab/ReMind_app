import 'package:flutter/material.dart';
import 'microphone_settings.dart'; // Import the new MicrophoneSettingsPage

class SettingsPage extends StatelessWidget {
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
