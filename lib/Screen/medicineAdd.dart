import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'medicineview.dart'; // Import the MedicineViewPage

class AddMedicineScreen extends StatefulWidget {
  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _pillNameController = TextEditingController();
  final List<String> _strengthOptions = [
    '5 mg',
    '10 mg',
    '20 mg',
    '50 mg',
    '100 mg'
  ];
  final List<String> _daysOfWeek = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  final List<String> _fullDaysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  final List<String> _frequencyOptions = [
    'Once a day',
    'Twice a day',
    'Three times a day'
  ];
  String? _selectedStrength;
  List<String> _selectedDays = [];
  String? _selectedFrequency;
  TimeOfDay? _selectedTime;
  String? _selectedFoodOption;
  List<bool> _isSelectedFoodOption = [true, false]; // Default to Before Food

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 41, 19, 76), // Dark Purple
        title: Text(
          'Add Medicine',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Back icon color
      ),
      backgroundColor: Colors
          .white, // Set the background color of the entire screen to white
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pill Name Input
            TextField(
              controller: _pillNameController,
              decoration: InputDecoration(
                labelText: 'Pill Name',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Color.fromARGB(
                          255, 59, 21, 94)), // Dark purple border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Color.fromARGB(
                          255, 59, 21, 94)), // Dark purple border
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),

            // Strength Dropdown
            DropdownButtonFormField<String>(
              value: _selectedStrength,
              decoration: InputDecoration(
                labelText: 'Strength',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Color.fromARGB(
                          255, 59, 21, 94)), // Dark purple border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Color.fromARGB(
                          255, 59, 21, 94)), // Dark purple border
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items: _strengthOptions.map((String strength) {
                return DropdownMenuItem<String>(
                  value: strength,
                  child: Text(strength),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStrength = newValue;
                });
              },
            ),
            SizedBox(height: 20),

            // Days of the Week
            Text('Days of the Week',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List<Widget>.generate(_daysOfWeek.length, (int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedDays.contains(_fullDaysOfWeek[index])) {
                        _selectedDays.remove(_fullDaysOfWeek[index]);
                      } else {
                        _selectedDays.add(_fullDaysOfWeek[index]);
                      }
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _selectedDays.contains(_fullDaysOfWeek[index])
                          ? Color.fromARGB(255, 59, 21, 94)
                          : Colors.grey.shade200,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color.fromARGB(255, 59, 21, 94),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _daysOfWeek[index],
                      style: TextStyle(
                        color: _selectedDays.contains(_fullDaysOfWeek[index])
                            ? Colors.white
                            : Color.fromARGB(255, 59, 21, 94),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Frequency Dropdown
            DropdownButtonFormField<String>(
              value: _selectedFrequency,
              decoration: InputDecoration(
                labelText: 'Frequency',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),

                  borderSide: BorderSide(
                      color: Color.fromARGB(
                          255, 59, 21, 94)), // Dark purple border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Color.fromARGB(
                          255, 59, 21, 94)), // Dark purple border
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items: _frequencyOptions.map((String frequency) {
                return DropdownMenuItem<String>(
                  value: frequency,
                  child: Text(frequency),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFrequency = newValue;
                });
              },
            ),
            SizedBox(height: 20),

            // Food Preference
            Text('Food Preference',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ToggleButtons(
              borderRadius: BorderRadius.circular(8.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Before Food'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('After Food'),
                ),
              ],
              isSelected: _isSelectedFoodOption,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _isSelectedFoodOption.length; i++) {
                    _isSelectedFoodOption[i] = i == index;
                  }
                  _selectedFoodOption =
                      index == 0 ? 'Before Food' : 'After Food';
                });
              },
            ),
            SizedBox(height: 20),

            // Select Reminder Time
            GestureDetector(
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(
                          primary:
                              Color.fromARGB(255, 41, 19, 76), // Dark Purple
                          onSurface:
                              Color.fromARGB(255, 59, 21, 94), // Dark Purple
                        ),
                        buttonTheme: ButtonThemeData(
                          colorScheme: ColorScheme.light(
                              primary: Color.fromARGB(
                                  255, 41, 19, 76)), // Dark Purple
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
              child: Row(
                children: [
                  Icon(Icons.access_time,
                      color: Color.fromARGB(255, 41, 19, 76)), // Dark Purple
                  SizedBox(width: 10),
                  Text(
                    _selectedTime == null
                        ? 'Select Reminder Time'
                        : 'Reminder Time: ${_selectedTime!.format(context)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 41, 19, 76), // Dark Purple
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Add Medicine Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final String pillName = _pillNameController.text;
                  final String? strength = _selectedStrength;
                  final List<String> days = _selectedDays;
                  final String? frequency = _selectedFrequency;
                  final String? foodOption = _selectedFoodOption;
                  final String? userEmail = _auth.currentUser?.email;

                  if (pillName.isNotEmpty &&
                      strength != null &&
                      days.isNotEmpty &&
                      frequency != null &&
                      _selectedTime != null &&
                      foodOption != null &&
                      userEmail != null) {
                    // Sort the days based on the predefined order
                    List<String> sortedDays = days
                      ..sort((a, b) {
                        int indexA = _fullDaysOfWeek.indexOf(a);
                        int indexB = _fullDaysOfWeek.indexOf(b);
                        return indexA.compareTo(indexB);
                      });

                    // Add the new medicine with user email
                    await FirebaseFirestore.instance
                        .collection('Medicines')
                        .add({
                      'pillName': pillName,
                      'strength': strength,
                      'days': sortedDays,
                      'frequency': frequency,
                      'foodOption': foodOption,
                      'remainderTime':
                          '${_selectedTime!.hour}:${_selectedTime!.minute}',
                      'userEmail': userEmail, // Save the user's email
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Medicine added successfully!')),
                    );

                    _pillNameController.clear();
                    setState(() {
                      _selectedStrength = null;
                      _selectedDays = [];
                      _selectedFrequency = null;
                      _selectedTime = null;
                      _selectedFoodOption = null;
                      _isSelectedFoodOption = [true, false];
                    });

                    // Navigate to MedicineViewPage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicineViewPage(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 41, 19, 76), // Dark Purple
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Add Medicine',
                    style: TextStyle(color: Colors.white)), // White text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
