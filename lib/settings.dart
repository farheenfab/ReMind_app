import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: const [
          SettingsTile(
            icon: Icons.info,
            title: 'About',
          ),
          SettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
          ),
          SettingsTile(
            icon: Icons.mic,
            title: 'Microphone Voice Settings',
          ),
          SettingsTile(
            icon: Icons.lock,
            title: 'Privacy and Security',
          ),
          SettingsTile(
            icon: Icons.exit_to_app,
            title: 'Log Out',
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const SettingsTile({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Handle tile tap
      },
    );
  }
}
