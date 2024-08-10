import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyDetailsPage extends StatefulWidget {
  @override
  _EmergencyDetailsPageState createState() => _EmergencyDetailsPageState();
}

class _EmergencyDetailsPageState extends State<EmergencyDetailsPage> {
  Map<String, dynamic>? emergencyData;
  bool isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loademergencyData();
  }

  Future<void> _loademergencyData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final email = user.email;

      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('emergency')
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final data = querySnapshot.docs.first.data() as Map<String, dynamic>;
          setState(() {
            emergencyData = data;
            _nameController.text = data['name'] ?? '';
            _phoneController.text = data['phone_number'] ?? '';
            _dobController.text = data['dob'] ?? '';
            _ageController.text = data['age'] ?? '';
            _genderController.text = data['gender'] ?? '';
          });
        }
      } catch (e) {
        print('Error fetching emergency details: $e');
      }
    } else {
      print('No user is logged in');
    }
  }

  Future<void> _updateEmergencyDetails() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;
      final updatedData = {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'dob': _dobController.text,
        'age': _ageController.text,
        'gender': _genderController.text,
        'email': user.email,
      };

      try {
        await FirebaseFirestore.instance
            .collection('emergency')
            .doc(userId)
            .update(updatedData);
        setState(() {
          emergencyData = updatedData;
          isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Emergency details updated')),
        );
      } catch (e) {
        print('Error updating emergency details: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Profile', style: TextStyle(color: Colors.white)), // White color for title
        backgroundColor: const Color.fromARGB(255, 41, 19, 76), // Dark purple color
        iconTheme: IconThemeData(color: Colors.white), // White color for back arrow and other icons
        actions: [
          if (!isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
          if (isEditing)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _updateEmergencyDetails();
              },
            ),
        ],
      ),
      body: emergencyData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color.fromARGB(255, 41, 19, 76), // Dark purple color
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      _nameController.text.isEmpty ? 'N/A' : _nameController.text,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 30),
                    _buildDetailField('Phone', _phoneController, isEditing),
                    _buildDetailField('Date of Birth', _dobController, isEditing),
                    _buildDetailField('Age', _ageController, isEditing),
                    _buildDetailField('Gender', _genderController, isEditing),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDetailField(
      String label, TextEditingController controller, bool isEditing) {
    return Container(
      width: double.infinity,
      child: Card(
        color: const Color.fromARGB(255, 41, 19, 76), // Dark purple color for cards
        margin: const EdgeInsets.only(bottom: 20.0),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              isEditing
                  ? TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                        ),
                        hintText: 'Enter $label',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                      ),
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      controller.text.isEmpty ? 'N/A' : controller.text,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
