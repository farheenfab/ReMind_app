import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
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
    return Card(
      margin: EdgeInsets.all(8.0),
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
                        FirebaseFirestore.instance
                            .collection('Medicine')
                            .doc(id)
                            .delete();
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
}
