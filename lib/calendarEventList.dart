import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editCalendarEvent.dart';
import 'pastel_colors.dart'; // Import the pastel colors file

class CalendarEventViewPage extends StatelessWidget {
  final DateTime selectedDay;

  const CalendarEventViewPage({
    Key? key,
    required this.selectedDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Adjust width as needed
      height: 300, // Adjust height as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('CalendarEvent')
                  .where('eventDate', isEqualTo: selectedDay.toIso8601String())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No events found.'));
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
  final Color color; // Add a color parameter
  final String id;
  final String eventName;
  final String eventDescription;
  final String eventLocation;
  final String eventTime;

  const EventCard({
    Key? key,
    required this.color, // Receive the color parameter
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
      color: color, // Use the passed color
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  eventName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
                        FirebaseFirestore.instance
                            .collection('CalendarEvent')
                            .doc(id)
                            .delete();
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
}
