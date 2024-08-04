import 'package:flutter/material.dart';
import 'package:alz_app/Screen/sosButton/alertPersonal.dart';
import 'package:alz_app/Screen/sosButton/callEmergency.dart';
import 'package:alz_app/Screen/sosButton/launchLocation.dart';

class SOSPage extends StatelessWidget {
  const SOSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Page'),
      ),
      body: Container(
        color: Color.fromARGB(255, 250, 165, 165), // Light grey background color
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
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40), // Space between the text and buttons
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
                    double latitude = 37.7749;
                    double longitude = -122.4194;
                    await launchMap(context, latitude, longitude);
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
              Icon(icon, color: Color.fromARGB(255, 191, 46, 35), size: 70.0), // Red icon on the left
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
