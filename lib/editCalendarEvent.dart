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
        title: const Text('Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: eventName,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
            TextField(
              controller: eventDescription,
              decoration: const InputDecoration(labelText: 'eventDescription'),
            ),
            TextField(
              controller: eventLocation,
              decoration: const InputDecoration(labelText: 'eventLocation'),
            ),
            TextField(
              controller: eventTime,
              decoration: const InputDecoration(labelText: 'eventTime'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateEvent,
              child: const Text('Update Event'),
            ),
          ],
        ),
      ),
    );
  }
}
