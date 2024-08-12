import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editCalendarEvent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pastel_colors.dart'; // Import the pastel colors file

class CalendarEventViewPage extends StatelessWidget {
  final DateTime selectedDay;

  const CalendarEventViewPage({
    Key? key,
    required this.selectedDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String? userEmail = _auth.currentUser?.email;
    // Define the start and end of the selected day
    DateTime startOfDay =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    DateTime endOfDay = DateTime(
        selectedDay.year, selectedDay.month, selectedDay.day, 23, 59, 59);

    return Container(
      width: 300, // Adjust width as needed
      height: 300, // Adjust height as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('CalendarEvents')
                  .where('userEmail', isEqualTo: userEmail)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No tasks for today.'));
                }

                final events = snapshot.data!.docs;

                return SingleChildScrollView(
                  child: Column(
                    children: events.asMap().entries.map((entry) {
                      int index = entry.key;
                      var event = entry.value;

                      // Get a pastel color based on the event index
                      Color cardColor = PastelColors.pastelColors[
                          index % PastelColors.pastelColors.length];

                      return EventCard(
                        color: cardColor, // Pass the color to EventCard
                        id: event.id,
                        eventName: event['eventName'],
                        eventDescription: event['eventDescription'],
                        eventLocation: event['eventLocation'],
                        eventTime: event['eventTime'],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Color color;
  final String id;
  final String eventName;
  final String eventDescription;
  final String eventLocation;
  final String eventTime;

  const EventCard({
    Key? key,
    required this.color,
    required this.id,
    required this.eventName,
    required this.eventDescription,
    required this.eventLocation,
    required this.eventTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    eventName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditEventPage(
                              id: id,
                              eventName: eventName,
                              eventDescription: eventDescription,
                              eventLocation: eventLocation,
                              eventTime: eventTime,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Event Description: $eventDescription'),
            const SizedBox(height: 8),
            Text('Location: $eventLocation'),
            const SizedBox(height: 8),
            Text('Time: $eventTime'),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFFD3D3D3), // Pastel grey color for background
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to delete this event?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('CalendarEvents')
                      .doc(id)
                      .delete()
                      .then((_) {
                    Navigator.of(context).pop(); // Close the dialog
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete event: $error')),
                    );
                  });
                },
              ),
              Divider(
                color: Colors.black,
              ),
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
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
