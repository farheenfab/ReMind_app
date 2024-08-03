import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> callEmergencyNumber(BuildContext context, String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not launch $phoneNumber')),
    );
  }
}



