import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_sms/background_sms.dart'; 
//- Uncomment this 


Future<void> sendAlertToEmergencyContacts(BuildContext context) async {
  PermissionStatus permissionStatus = await getSmsPermission();
  if (permissionStatus != PermissionStatus.granted) {
    return;
  }

  List<String> emergencyContacts = ["971504184327"];

  // Comment the below 
  // for (String contact in emergencyContacts) {
  //   await simulateSendSMS("This is an emergency alert!", contact);
  // }

  for (String contact in emergencyContacts) {
    await sendSMS("This is an emergency alert!", contact);
  } 
  // Uncomment this

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ConfirmationScreen()),
  );
}

Future<PermissionStatus> getSmsPermission() async {
  PermissionStatus permission = await Permission.sms.status;
  if (permission != PermissionStatus.granted) {
    permission = await Permission.sms.request();
  }
  return permission;
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
// Uncomment this

//Comment the below function
Future<void> simulateSendSMS(String message, String recipient) async {
  print("Simulated SMS sent to $recipient: $message");
}

class ConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
      ),
      body: Center(
        child: Text(
          'Alert sent to emergency contacts!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
