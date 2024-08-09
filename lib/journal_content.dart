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
        title: Text('Journal Entry: $date'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white, // Set the background color to white
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${daysOfWeek[DateTime.parse(date).weekday]}"),
              Text(time),
              const SizedBox(height: 20), // Space between elements
              Text(content),
            ],
          ),
        ),
      ),
    );
  }
}
