import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_sms/background_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> sendAlertToEmergencyContacts(BuildContext context) async {
  // Request SMS permission
  final smsPermissionStatus = await Permission.sms.request();
  if (smsPermissionStatus.isDenied) {
    // Show a dialog explaining why SMS permission is needed and guide to settings
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SMS Permission Required'),
        content: const Text(
          'This app needs SMS permission to send alerts to your emergency contacts. Please grant SMS permission in the app settings.',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              openAppSettings(); // Opens app settings to grant permission
              Navigator.of(context).pop();
            },
          ),
        ],
        backgroundColor: Colors.grey, // Set pop-up background color to grey
      ),
    );
    return;
  }

  if (smsPermissionStatus.isPermanentlyDenied) {
    // Show a message informing the user that permission was permanently denied
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'SMS permission is permanently denied. You need to enable it in the app settings.')),
    );
    return;
  }

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User not logged in')),
    );
    return;
  }

  final email = user.email;

  List<String> emergencyContacts = await _getEmergencyContacts(email);
  List<String> caretakerContacts = await _getCaretakerContacts(email);

  final allContacts = [...emergencyContacts, ...caretakerContacts];

  for (String contact in allContacts) {
    await sendSMS("This is an emergency alert!", contact);
  }

  // Show the alert pop-up after sending the alert
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Alert Sent'),
      content: const Text('Alert sent to emergency contacts!'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
      backgroundColor: const Color.fromARGB(
          255, 255, 255, 255), // Set pop-up background color to grey
    ),
  );
}

Future<void> sendSMS(String message, String recipient) async {
  SmsStatus result = await BackgroundSms.sendMessage(
    phoneNumber: recipient,
    message: message,
  );
  if (result == SmsStatus.sent) {
    print("SMS sent successfully to $recipient");
  } else {
    print("Failed to send SMS to $recipient");
  }
}

Future<List<String>> _getEmergencyContacts(String? email) async {
  final List<String> contacts = [];
  if (email != null) {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('emergency')
        .where('email', isEqualTo: email)
        .get();

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final phoneNumber = data['phone_number'];
      if (phoneNumber != null) {
        contacts.add(phoneNumber);
      }
    }
  }
  return contacts;
}

Future<List<String>> _getCaretakerContacts(String? email) async {
  final List<String> contacts = [];
  if (email != null) {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('caretaker')
        .where('email', isEqualTo: email)
        .get();

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final phoneNumber = data['phone_number'];
      if (phoneNumber != null) {
        contacts.add(phoneNumber);
      }
    }
  }
  return contacts;
}
