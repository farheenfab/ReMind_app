import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'medicineview.dart'; // Import the MedicineViewPage

class AddMedicineScreen extends StatefulWidget {
  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _pillNameController = TextEditingController();
  final List<String> _strengthOptions = ['5 mg', '10 mg', '20 mg', '50 mg', '100 mg'];
  final List<String> _daysOfWeek = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  final List<String> _fullDaysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  final List<String> _frequencyOptions = ['Once a day', 'Twice a day', 'Three times a day'];
  String? _selectedStrength;
  List<String> _selectedDays = [];
  String? _selectedFrequency;
  TimeOfDay? _selectedTime;
  String? _selectedFoodOption;
  List<bool> _isSelectedFoodOption = [true, false]; // Default to Before Food

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medicine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _pillNameController,
                decoration: InputDecoration(labelText: 'Pill Name'),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedStrength,
                decoration: InputDecoration(labelText: 'Strength'),
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
              Text('Days of the Week'),
              SizedBox(height: 10),
              Wrap(
                spacing: 4.0,
                children: List<Widget>.generate(_daysOfWeek.length, (int index) {
                  return ChoiceChip(
                    label: Text(_daysOfWeek[index]),
                    selected: _selectedDays.contains(_fullDaysOfWeek[index]),
                    shape: CircleBorder(),
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: Colors.grey.shade300, // Changed to remove the tick mark appearance
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedDays.add(_fullDaysOfWeek[index]);
                        } else {
                          _selectedDays.remove(_fullDaysOfWeek[index]);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedFrequency,
                decoration: InputDecoration(labelText: 'Frequency'),
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
              Text('Food Preference'),
              SizedBox(height: 10),
              ToggleButtons(
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
                    _selectedFoodOption = index == 0 ? 'Before Food' : 'After Food';
                  });
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedTime = picked;
                    });
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 10),
                    Text(
                      _selectedTime == null
                          ? 'Select Reminder Time'
                          : 'Reminder Time: ${_selectedTime!.format(context)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final String pillName = _pillNameController.text;
                  final String? strength = _selectedStrength;
                  final List<String> days = _selectedDays;
                  final String? frequency = _selectedFrequency;
                  final String? foodOption = _selectedFoodOption;

                  if (pillName.isNotEmpty && strength != null && days.isNotEmpty && frequency != null && _selectedTime != null && foodOption != null) {
                    // Check if the pill already exists in the database
                    final QuerySnapshot result = await FirebaseFirestore.instance
                        .collection('Medicine')
                        .where('pillName', isEqualTo: pillName)
                        .get();

                    final List<DocumentSnapshot> documents = result.docs;

                    if (documents.isEmpty) {
                      // Sort the days based on the predefined order
                      List<String> sortedDays = days..sort((a, b) {
                        int indexA = _fullDaysOfWeek.indexOf(a);
                        int indexB = _fullDaysOfWeek.indexOf(b);
                        return indexA.compareTo(indexB);
                      });

                      // Add the new medicine if it doesn't exist
                      await FirebaseFirestore.instance.collection('Medicine').add({
                        'pillName': pillName,
                        'strength': strength,
                        'days': sortedDays,
                        'frequency': frequency,
                        'foodOption': foodOption,
                        'remainderTime': '${_selectedTime!.hour}:${_selectedTime!.minute}',
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
                    } else {
                      // Show a message if the pill already exists
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('This medicine already exists.')),
                      );
                    }
                  }
                },
                child: Text('Add Medicine'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
