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
    FirebaseFirestore.instance.collection('Medicines').doc(widget.id).update({
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
        title: Text(
          'Edit Medicine',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 41, 19, 76), // Purple background color
        iconTheme: IconThemeData(
          color: Colors.white, // White color for the back arrow icon
        ),
      ),
      backgroundColor: Colors.white, // Background color of the whole screen set to white
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView( // Added SingleChildScrollView to prevent overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(pillNameController, 'Pill Name', Icons.medication),
              SizedBox(height: 15),
              _buildTextField(strengthController, 'Strength', Icons.info_outline),
              SizedBox(height: 15),
              _buildTextField(daysController, 'Days', Icons.calendar_today),
              SizedBox(height: 15),
              _buildTextField(frequencyController, 'Frequency', Icons.schedule),
              SizedBox(height: 15),
              _buildTextField(foodOptionController, 'Food Option', Icons.restaurant),
              SizedBox(height: 15),
              _buildTextField(remainderTimeController, 'Reminder Time', Icons.alarm),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: updateMedicine,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 41, 19, 76), // Purple color
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    'Update Medicine',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Color.fromARGB(255, 59, 21, 94)), // Purple icon color
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
          borderSide: BorderSide(color: Color.fromARGB(255, 59, 21, 94)), // Dark purple border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
          borderSide: BorderSide(color: Color.fromARGB(255, 59, 21, 94)), // Dark purple border when focused
        ),
      ),
    );
  }
}
