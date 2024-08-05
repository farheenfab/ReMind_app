import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'editMedicine.dart';
import 'medicineAdd.dart';

class MedicineViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Medicine View'),
            IconButton(
              icon: Icon(Icons.add, color: Colors.black),
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
      ),
      body: MedicineList(),
      backgroundColor: Colors.white, // Set the background color of the page to white
    );
  }
}

class MedicineList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Medicine').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Center(child: Text('No medicines found.'));
        }

        final medicines = snapshot.data!.docs;

        return ListView.builder(
          itemCount: medicines.length,
          itemBuilder: (context, index) {
            final medicine = medicines[index];

            return MedicineCard(
              id: medicine.id,
              pillName: medicine['pillName'],
              strength: medicine['strength'],
              days: List<String>.from(medicine['days']),
              frequency: medicine['frequency'],
              foodOption: medicine['foodOption'],
              remainderTime: medicine['remainderTime'],
            );
          },
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
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: _getPastelColor(), // Set the container color to a pastel color
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1), // Black border
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pillName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
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
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Strength: $strength'),
            SizedBox(height: 8),
            Text('Days: ${days.join(', ')}'),
            SizedBox(height: 8),
            Text('Frequency: $frequency'),
            SizedBox(height: 8),
            Text('Food Option: $foodOption'),
            SizedBox(height: 8),
            Text('Reminder Time: $remainderTime'),
          ],
        ),
      ),
    );
  }

  // Helper function to get a random pastel color
  Color _getPastelColor() {
    final pastelColors = [
      Color(0xFFFFF1E6), // Light Peach
      Color(0xFFE0F7FA), // Light Cyan
      Color(0xFFFFF9C4), // Light Yellow
      Color(0xFFE1BEE7), // Light Lavender
      Color(0xFFC8E6C9), // Light Green
    ];
    return pastelColors[id.hashCode % pastelColors.length];
  }

  void _showDeleteConfirmationDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this medicine?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('Medicine')
                    .doc(id)
                    .delete()
                    .then((_) {
                  Navigator.of(context).pop(); // Close the dialog
                }).catchError((error) {
                  // Handle any errors here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete medicine: $error')),
                  );
                });
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
  }
}
