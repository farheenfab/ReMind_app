import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchMap(BuildContext context, double latitude, double longitude) async {
  final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

  if (await canLaunch(googleMapsUrl)) {
    await launch(googleMapsUrl);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not launch Google Maps')),
    );
  }
}
