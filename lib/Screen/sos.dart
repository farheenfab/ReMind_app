import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:alz_app/Screen/sosButton/alertPersonal.dart';
import 'package:alz_app/Screen/sosButton/callEmergency.dart';

class SOSPage extends StatefulWidget {
  const SOSPage({super.key});

  @override
  _SOSPageState createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  Future<Map<String, double>?> _getPatientLocation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Patients')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['location'] != null) {
          final locationString = data['location'] as String;

          // Extract latitude and longitude from the string
          final latitudeRegex = RegExp(r'Latitude:\s*([\d.-]+)');
          final longitudeRegex = RegExp(r'Longitude:\s*([\d.-]+)');

          final latitudeMatch = latitudeRegex.firstMatch(locationString);
          final longitudeMatch = longitudeRegex.firstMatch(locationString);

          if (latitudeMatch != null && longitudeMatch != null) {
            final latitude = double.tryParse(latitudeMatch.group(1) ?? '');
            final longitude = double.tryParse(longitudeMatch.group(1) ?? '');

            if (latitude != null && longitude != null) {
              return {'latitude': latitude, 'longitude': longitude};
            }
          }
        }
      }
    }
    return null;
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      // Request permission
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      // Show a message to the user about manually enabling permissions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Location permission is permanently denied. Please enable it from settings.'),
        ),
      );
      // Optionally, redirect user to app settings
      await openAppSettings();
    }
  }

  Future<void> launchMap(double latitude, double longitude) async {
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    final Uri uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch Google Maps.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Page'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 180, 54, 54), // Dark red
              Color.fromARGB(255, 219, 99, 99), // Red
              Color(0xFFFFA07A), // Light red (light salmon)
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'PLEASE, CHOOSE THE EMERGENCY FROM BELOW',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                SOSButton(
                  icon: Icons.phone,
                  text: 'Send alert to caretaker & emergency contact',
                  onPressed: () async {
                    await sendAlertToEmergencyContacts(context);
                  },
                ),
                const SizedBox(height: 40),
                SOSButton(
                  icon: Icons.location_on,
                  text: 'Lost? Click here for your way back home!',
                  onPressed: () async {
                    await requestLocationPermission();
                    final location = await _getPatientLocation();
                    if (location != null) {
                      await launchMap(
                          location['latitude']!, location['longitude']!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Location not found.')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 40),
                SOSButton(
                  icon: Icons.local_hospital,
                  text: 'Medical Emergency? Click here to call 911!',
                  onPressed: () async {
                    await callEmergencyNumber(context, '911');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SOSButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const SOSButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Curved border
        side: BorderSide(color: Colors.black, width: 1.0), // Black border
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Row(
            children: [
              Icon(icon,
                  color: Color.fromARGB(255, 191, 46, 35),
                  size: 70.0), // Red icon on the left
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 22, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
