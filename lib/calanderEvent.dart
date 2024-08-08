import 'package:flutter/material.dart';
import 'calendarDB.dart';
import 'calender_page.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CalendarPage()),
          ),
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16.0), // Reduce side padding
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity, // Use full width available
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0), // Vertical spacing
                      child: TextField(
                        controller: eventName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Event Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0), // Vertical spacing
                      child: TextField(
                        controller: eventDescription,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Event Description (Optional)',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0), // Vertical spacing
                      child: TextField(
                        controller: eventLocation,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Event Location (Optional)',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0), // Vertical spacing
                      child: TextField(
                        controller: eventTime,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Event Time (Optional)',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20), // Spacing between buttons

            ElevatedButton(
              child: const Text('Create Event'),
              onPressed: () async {
                await DatabaseService().addData(
                  widget.selectedDate
                      .toIso8601String(), // Use the selected date
                  eventName.text,
                  eventDescription.text,
                  eventLocation.text,
                  eventTime.text,
                  DateTime.now(),
                );

                eventName.clear();
                eventDescription.clear();
                eventLocation.clear();
                eventTime.clear();

                Navigator.of(context).pop();
              },
            ),

            SizedBox(height: 10), // Spacing between buttons

            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
