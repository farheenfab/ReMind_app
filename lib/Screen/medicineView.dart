import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'editMedicine.dart';
import 'medicineAdd.dart';

class MedicineViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(
            255, 41, 19, 76), // Dark Purple background color for AppBar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Medicine View', style: TextStyle(color: Colors.white)),
            IconButton(
              icon: Icon(Icons.add, color: Colors.white), // White icon color
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMedicineScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        iconTheme:
            IconThemeData(color: Colors.white), // Set back arrow color to white
      ),
      body: MedicineList(),
      backgroundColor:
          Color(0xFFFFFFFF), // Set the background color of the page to white
    );
  }
}

class MedicineList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String? userEmail = _auth.currentUser?.email;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Medicines')
          .where('userEmail', isEqualTo: userEmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No medicines found.'));
        }

        final medicines = snapshot.data!.docs;

        // Sort medicines by day of the week
        final daysOfWeek = [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday'
        ];
        final Map<String, List<QueryDocumentSnapshot>> sortedMedicines = {
          for (var day in daysOfWeek) day: []
        };

        for (var medicine in medicines) {
          for (var day in medicine['days']) {
            sortedMedicines[day]?.add(medicine);
          }
        }

        return ListView(
          children: daysOfWeek.map((day) {
            final dayMedicines = sortedMedicines[day] ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(
                          255, 41, 19, 76), // Dark Purple text color
                    ),
                  ),
                ),
                if (dayMedicines.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'No medicines for the day',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  ...dayMedicines.map((medicine) {
                    return MedicineCard(
                      id: medicine.id,
                      pillName: medicine['pillName'],
                      strength: medicine['strength'],
                      days: List<String>.from(medicine['days']),
                      frequency: medicine['frequency'],
                      foodOption: medicine['foodOption'],
                      remainderTime: medicine['remainderTime'],
                    );
                  }).toList(),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

class MedicineCard extends StatelessWidget {
  final String id;
  final String pillName;
  final String strength;
  final List<String> days;
  final String frequency;
  final String foodOption;
  final String remainderTime;

  MedicineCard({
    required this.id,
    required this.pillName,
    required this.strength,
    required this.days,
    required this.frequency,
    required this.foodOption,
    required this.remainderTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 224, 204, 240), // Light Pastel Purple color
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: Colors.black.withOpacity(0.1), width: 1), // Subtle border
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    pillName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(
                          255, 41, 19, 76), // Dark Purple text color
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit,
                          color: Color.fromARGB(255, 21, 94,
                              37)), // Dark Green icon color for edit
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditMedicinePage(
                              id: id,
                              pillName: pillName,
                              strength: strength,
                              days: days,
                              frequency: frequency,
                              foodOption: foodOption,
                              remainderTime: remainderTime,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete,
                          color:
                              Color(0xFFB71C1C)), // Red icon color for delete
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, id, days);
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Strength: $strength', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Days: ${days.join(', ')}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Frequency: $frequency', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Food Option: $foodOption', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Reminder Time: $remainderTime',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, String id, List<String> days) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Color(0xFFD3D3D3), // Pastel grey color for background
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to delete this medicine ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Bold text
                  fontSize: 17.0, // Increased text size
                  color: Colors.black, // Text color
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0, // Bold text
                  ),
                ),
                onPressed: () {
                  if (days.length > 1) {
                    // Update the document by removing the selected day
                    days.removeWhere((day) =>
                        day == days[0]); // Example for deleting the first day
                    FirebaseFirestore.instance
                        .collection('Medicines')
                        .doc(id)
                        .update({'days': days}).then((_) {
                      Navigator.of(context).pop(); // Close the dialog
                    }).catchError((error) {
                      // Handle any errors here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Failed to delete medicine for the day: $error')),
                      );
                    });
                  } else {
                    // If it's the only day, delete the entire document
                    FirebaseFirestore.instance
                        .collection('Medicines')
                        .doc(id)
                        .delete()
                        .then((_) {
                      Navigator.of(context).pop(); // Close the dialog
                    }).catchError((error) {
                      // Handle any errors here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to delete medicine: $error')),
                      );
                    });
                  }
                },
              ),
              Divider(
                color: Colors.black, // Divider color
              ),
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0, // Bold text
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
