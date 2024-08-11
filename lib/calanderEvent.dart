import 'package:flutter/material.dart';
import 'calendarDB.dart';
import 'calender_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarEvent extends StatefulWidget {
  final DateTime selectedDate;

  const CalendarEvent({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<CalendarEvent> createState() => _CalendarEventState();
}

class _CalendarEventState extends State<CalendarEvent> {
  TextEditingController eventDescription = TextEditingController();
  TextEditingController eventName = TextEditingController();
  TextEditingController eventLocation = TextEditingController();
  TextEditingController eventTime = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String? userEmail = _auth.currentUser?.email;
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Create Event',
            style: TextStyle(color: Colors.white), // White text color
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CalendarPage()),
          ),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white, // White back arrow color
          ),
        ),
        backgroundColor: const Color.fromARGB(
            255, 41, 19, 76), // Dark purple background color
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: eventName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(
                                255, 41, 19, 76)), // Dark purple outline
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color(
                                0xFF382973)), // Dark purple outline when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color(
                                0xFF382973)), // Dark purple outline when focused
                      ),
                      hintText: 'Enter Event Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: eventDescription,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(
                                255, 41, 19, 76)), // Dark purple outline
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color(
                                0xFF382973)), // Dark purple outline when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color(
                                0xFF382973)), // Dark purple outline when focused
                      ),
                      hintText: 'Enter Event Description (Optional)',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: eventLocation,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(
                                255, 41, 19, 76)), // Dark purple outline
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color(
                                0xFF382973)), // Dark purple outline when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color(
                                0xFF382973)), // Dark purple outline when focused
                      ),
                      hintText: 'Enter Event Location (Optional)',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: eventTime,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(
                                255, 41, 19, 76)), // Dark purple outline
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color(
                                0xFF382973)), // Dark purple outline when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color(
                                0xFF382973)), // Dark purple outline when focused
                      ),
                      hintText: 'Enter Event Time (Optional)',
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Spacing between buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: const Color(
                          0xFF382973), // Dark purple background color
                      foregroundColor: Colors.white, // White text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize:
                          const Size(double.infinity, 50), // Button height
                    ),
                    child: const Text(
                      'Create Event',
                      style: TextStyle(fontSize: 20), // Text size
                    ),
                    onPressed: () async {
                      await DatabaseService().addData(
                          widget.selectedDate
                              .toIso8601String(), // Use the selected date
                          eventName.text,
                          eventDescription.text,
                          eventLocation.text,
                          eventTime.text,
                          DateTime.now(),
                          userEmail.toString());

                      eventName.clear();
                      eventDescription.clear();
                      eventLocation.clear();
                      eventTime.clear();

                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(height: 10), // Spacing between buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: const Color(
                          0xFF382973), // Dark purple background color
                      foregroundColor: Colors.white, // White text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize:
                          const Size(double.infinity, 50), // Button height
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 20), // Text size
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
