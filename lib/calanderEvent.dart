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
      backgroundColor: Colors.white, // Set background color to white
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
                            borderSide: BorderSide(
                                color:
                                    Color(0xFF382973)), // Dark purple outline
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0), // Vertical spacing
                      child: TextField(
                        controller: eventDescription,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color:
                                    Color(0xFF382973)), // Dark purple outline
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
                            borderSide: BorderSide(
                                color:
                                    Color(0xFF382973)), // Dark purple outline
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
                            borderSide: BorderSide(
                                color:
                                    Color(0xFF382973)), // Dark purple outline
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
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color(0xFF382973), // Dark purple background color
                foregroundColor: Colors.white, //
                minimumSize: Size(double.infinity, 40), // Button height
                textStyle: TextStyle(fontSize: 18), // Text size
              ),
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

            SizedBox(height: 10, width: 20.0), // Spacing between buttons

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color(0xFF382973), // Dark purple background color
                foregroundColor: Colors.white, // White text color
                minimumSize: Size(double.infinity, 40), // Button height
                textStyle: TextStyle(fontSize: 18), // Text size
              ),
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
