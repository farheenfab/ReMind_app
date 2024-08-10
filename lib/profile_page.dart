import 'package:flutter/material.dart';
import 'patientDtls.dart';  // Import the PatientDetailsPage
import 'caretakerPage.dart';  // Import the CaretakerDetailsPage
import 'emergency_page.dart';  // Import the EmergencyDetailsPage

class ProfileDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 41, 19, 76), // Dark Purple background color for AppBar
        title: Text(
          'Profile Details',
          style: TextStyle(color: Colors.white), // Set title color to white
        ),
        iconTheme: IconThemeData(color: Colors.white), // Set back arrow color to white
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 2.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // Set the background color of the entire page
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Patient Details Button
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PatientDetailsPage(), // Navigate to PatientDetailsPage
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 41, 19, 76),  // Container background color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 70,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Patient Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Caretaker Details Button
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CaretakerDetailsPage(), // Navigate to CaretakerDetailsPage
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 41, 19, 76),  // Container background color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 70,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Caretaker Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Emergency Contact Details Button
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EmergencyDetailsPage(), // Navigate to EmergencyDetailsPage
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 41, 19, 76),  // Container background color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 70,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Emergency Contact Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
