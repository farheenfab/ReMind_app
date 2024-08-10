import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEventPage extends StatefulWidget {
  final String id;
  final String eventName;
  final String eventDescription;
  final String eventLocation;
  final String eventTime;

  EditEventPage({
    required this.id,
    required this.eventName,
    required this.eventDescription,
    required this.eventLocation,
    required this.eventTime,
  });

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late TextEditingController eventDescription = TextEditingController();
  late TextEditingController eventName = TextEditingController();
  late TextEditingController eventLocation = TextEditingController();
  late TextEditingController eventTime = TextEditingController();

  @override
  void initState() {
    super.initState();
    eventName = TextEditingController(text: widget.eventName);
    eventDescription = TextEditingController(text: widget.eventDescription);
    eventLocation = TextEditingController(text: widget.eventLocation);
    eventTime = TextEditingController(text: widget.eventTime);
  }

  void updateEvent() {
    FirebaseFirestore.instance
        .collection('CalendarEvent')
        .doc(widget.id)
        .update({
      'eventName': eventName.text,
      'eventDescription': eventDescription.text,
      'eventLocation': eventLocation.text,
      'eventTime': eventTime.text,
      'eventTimestamp': DateTime.now(),
    }).then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Event',
          style:
              TextStyle(color: Colors.white), // Set AppBar text color to white
        ),
        backgroundColor: Color(0xFF382973), // Dark purple background color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // White color for back arrow
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: eventName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: Color(0xFF382973)), // Dark purple outline
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: Color(
                            0xFF382973)), // Dark purple outline when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
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
                    borderSide: BorderSide(
                        color: Color(0xFF382973)), // Dark purple outline
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: Color(
                            0xFF382973)), // Dark purple outline when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: Color(
                            0xFF382973)), // Dark purple outline when focused
                  ),
                  hintText: 'Enter Event Description',
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
                    borderSide: BorderSide(
                        color: Color(0xFF382973)), // Dark purple outline
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: Color(
                            0xFF382973)), // Dark purple outline when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: Color(
                            0xFF382973)), // Dark purple outline when focused
                  ),
                  hintText: 'Enter Event Location',
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
                    borderSide: BorderSide(
                        color: Color(0xFF382973)), // Dark purple outline
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: Color(
                            0xFF382973)), // Dark purple outline when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: Color(
                            0xFF382973)), // Dark purple outline when focused
                  ),
                  hintText: 'Enter Event Time',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateEvent,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color(0xFF382973), // Dark purple background color
                foregroundColor: Colors.white, // White text color
                minimumSize: Size(double.infinity, 40), // Button height
                textStyle: TextStyle(fontSize: 18), // Text size
              ),
              child: const Text('Update Event'),
            ),
          ],
        ),
      ),
    );
  }
}
