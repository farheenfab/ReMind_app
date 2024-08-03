import 'package:alz_app/Screen/sosButton/alertPersonal.dart';
import 'package:flutter/material.dart';
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await sendAlertToEmergencyContacts(context);
                },
                child: const Text('Send alert to emergency contacts'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  double latitude = 37.7749;
                  double longitude = -122.4194;
                  await launchMap(context, latitude, longitude);
                },
                child: const Text('Lost! Find me!'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await callEmergencyNumber(context, '911');
                },
                child: const Text('Medical Emergency! Call 911!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
