import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchMap(
    BuildContext context, double latitude, double longitude) async {
  final String googleMapsUrl =
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
  final Uri uri = Uri.parse(googleMapsUrl);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not launch Google Maps')),
    );
  }
}
