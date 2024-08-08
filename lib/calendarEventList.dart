import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'editCalendarEvent.dart';

class CalendarEventViewPage extends StatelessWidget {
  final DateTime selectedDay;

  const CalendarEventViewPage({
    Key? key,
    required this.selectedDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Events for ${selectedDay.toLocal().toString().split(' ')[0]}'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('CalendarEvent')
            .where('eventDate',
                isEqualTo: selectedDay
                    .toIso8601String()) // Filter events by selectedDay
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No events found.'));
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];

              return EventCard(
                id: event.id,
                eventName: event['eventName'],
                eventDescription: event['eventDescription'],
                eventLocation: event['eventLocation'],
                eventTime: event['eventTime'],
              );
            },
          );
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String id;
  final String eventName;
  final String eventDescription;
  final String eventLocation;
  final String eventTime;

  const EventCard({
    Key? key,
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
