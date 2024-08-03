import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditMedicinePage extends StatefulWidget {
  final String id;
  final String pillName;
  final String strength;
  final List<String> days;
  final String frequency;
  final String foodOption;
  final String remainderTime;

  EditMedicinePage({
    required this.id,
    required this.pillName,
    required this.strength,
    required this.days,
    required this.frequency,
    required this.foodOption,
    required this.remainderTime,
  });

  @override
  _EditMedicinePageState createState() => _EditMedicinePageState();
}

class _EditMedicinePageState extends State<EditMedicinePage> {
  late TextEditingController pillNameController;
  late TextEditingController strengthController;
  late TextEditingController daysController;
  late TextEditingController frequencyController;
  late TextEditingController foodOptionController;
  late TextEditingController remainderTimeController;

  @override
  void initState() {
    super.initState();
    pillNameController = TextEditingController(text: widget.pillName);
    strengthController = TextEditingController(text: widget.strength);
    daysController = TextEditingController(text: widget.days.join(', '));
    frequencyController = TextEditingController(text: widget.frequency);
    foodOptionController = TextEditingController(text: widget.foodOption);
    remainderTimeController = TextEditingController(text: widget.remainderTime);
  }

  void updateMedicine() {
    FirebaseFirestore.instance.collection('Medicine').doc(widget.id).update({
      'pillName': pillNameController.text,
      'strength': strengthController.text,
      'days': daysController.text.split(', ').toList(),
      'frequency': frequencyController.text,
      'foodOption': foodOptionController.text,
      'remainderTime': remainderTimeController.text,
    }).then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Medicine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: pillNameController,
              decoration: InputDecoration(labelText: 'Pill Name'),
            ),
            TextField(
              controller: strengthController,
              decoration: InputDecoration(labelText: 'Strength'),
            ),
            TextField(
              controller: daysController,
              decoration: InputDecoration(labelText: 'Days'),
            ),
            TextField(
              controller: frequencyController,
              decoration: InputDecoration(labelText: 'Frequency'),
            ),
            TextField(
              controller: foodOptionController,
              decoration: InputDecoration(labelText: 'Food Option'),
            ),
            TextField(
              controller: remainderTimeController,
              decoration: InputDecoration(labelText: 'Reminder Time'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateMedicine,
              child: Text('Update Medicine'),
            ),
          ],
        ),
      ),
    );
  }
}
