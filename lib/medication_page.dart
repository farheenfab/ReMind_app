import 'package:flutter/material.dart';

class MedicationPage extends StatefulWidget {
  @override
  _MedicationPageState createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medication'),
      ),
      body: Center(
        child: Text('This is the Medication Page'),
      ),
    );
  }
}