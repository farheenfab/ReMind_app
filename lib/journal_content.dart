import 'package:flutter/material.dart';

class DisplayJournalData {
  final String date;
  final String time;
  final String content;
  DisplayJournalData(
      {required this.date, required this.time, required this.content});
}

class Display_Journal_Data extends StatelessWidget {
  final String date;
  final String time;
  final String content;

  Map<int, String> daysOfWeek = {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
    7: 'Sunday',
  };

  Display_Journal_Data(
      {super.key,
      required this.date,
      required this.time,
      required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 41, 19, 76), // Dark purple background color
        title: Align(
          alignment: Alignment.centerLeft, // Align title to the left
          child: Text(
            'Journal Entry: $date',
            style: const TextStyle(color: Colors.white), // White title color
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white, // White back arrow color
        ),
      ),
      body: Container(
        color: Colors.white, // Set the background color to white
        padding: const EdgeInsets.all(16.0), // Add padding around the content
        child: SingleChildScrollView(
          // Make the content scrollable
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align text to the start
            children: [
              Text(
                "${daysOfWeek[DateTime.parse(date).weekday]}",
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8), // Space between elements
              Text(
                time,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20), // Space between elements
              Text(
                content,
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
