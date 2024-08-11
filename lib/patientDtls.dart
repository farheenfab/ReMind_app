import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientDetailsPage extends StatefulWidget {
  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  Map<String, dynamic>? patientData;
  bool isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final email = user.email;

      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('Patients')
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final data = querySnapshot.docs.first.data() as Map<String, dynamic>;
          setState(() {
            patientData = data;
            _nameController.text = data['name'] ?? '';
            _phoneController.text = data['phone'] ?? '';
            _dobController.text = data['dob'] ?? '';
            _ageController.text = data['age'] ?? '';
            _genderController.text = data['gender'] ?? '';
            _locationController.text = _getLocationString(data['location']);
          });
        }
      } catch (e) {
        print('Error fetching patient details: $e');
      }
    } else {
      print('No user is logged in');
    }
  }

  String _getLocationString(dynamic location) {
    if (location is Map<String, dynamic>) {
      final latitude = location['latitude'];
      final longitude = location['longitude'];
      return 'Latitude: ${latitude?.toString() ?? 'N/A'}, Longitude: ${longitude?.toString() ?? 'N/A'}';
    }
    return 'Location Selected';
  }

  Future<void> _updatePatientDetails() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;
      final updatedData = {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'dob': _dobController.text,
        'age': _ageController.text,
        'gender': _genderController.text,
        'location': _parseLocation(_locationController.text),
        'email': user.email,
      };

      try {
        await FirebaseFirestore.instance
            .collection('Patients')
            .doc(userId)
            .update(updatedData);
        setState(() {
          patientData = updatedData;
          isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Patient details updated')),
        );
      } catch (e) {
        print('Error updating patient details: $e');
      }
    }
  }

  Map<String, dynamic> _parseLocation(String locationStr) {
    final parts = locationStr.split(',');
    if (parts.length == 2) {
      final latitude =
          double.tryParse(parts[0].replaceAll('Latitude:', '').trim());
      final longitude =
          double.tryParse(parts[1].replaceAll('Longitude:', '').trim());
      return {
        'latitude': latitude,
        'longitude': longitude,
      };
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient Profile',
          style: TextStyle(color: Colors.white), // Title color changed to white
        ),
        backgroundColor:
            const Color.fromARGB(255, 41, 19, 76), // Dark purple color
        iconTheme: IconThemeData(
          color: Colors.white, // White color for icons
        ),
        actions: [
          if (!isEditing)
            IconButton(
              icon: Icon(Icons.edit,
                  color: Colors.white), // Edit icon color changed to white
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
          if (isEditing)
            IconButton(
              icon: Icon(Icons.save,
                  color: Colors.white), // Save icon color changed to white
              onPressed: () {
                _updatePatientDetails();
              },
            ),
        ],
      ),
      backgroundColor: Colors.white, // Change the background color to white
      body: patientData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color.fromARGB(
                          255, 41, 19, 76), // Dark purple color
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      _nameController.text.isEmpty
                          ? 'N/A'
                          : _nameController.text,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(
                            255, 0, 0, 0), // White text color
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      patientData?['email'] ?? 'N/A',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(
                              179, 77, 75, 75)), // Light white color for text
                    ),
                    SizedBox(height: 30),
                    _buildDetailField('Phone', _phoneController, isEditing),
                    _buildDetailField(
                        'Date of Birth', _dobController, isEditing),
                    _buildDetailField('Age', _ageController, isEditing),
                    _buildDetailField('Gender', _genderController, isEditing),
                    _buildDetailField(
                        'Location', _locationController, isEditing),
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
        color: const Color.fromARGB(
            255, 41, 19, 76), // Dark purple color for cards
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
                  color: Colors.white, // Label color changed to white
                ),
              ),
              SizedBox(height: 8),
              isEditing
                  ? TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                              color: Colors
                                  .white), // Border color changed to white
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                              color: Colors.white,
                              width:
                                  2.0), // Focused border color changed to white
                        ),
                        hintText: 'Enter $label',
                        hintStyle: TextStyle(
                            color: Colors
                                .white70), // Hint text color changed to light white
                      ),
                      style: TextStyle(
                          color: Colors.white), // Text color changed to white
                    )
                  : Text(
                      controller.text.isEmpty ? 'N/A' : controller.text,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // Text color changed to white
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
