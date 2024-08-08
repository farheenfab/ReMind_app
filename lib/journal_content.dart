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
        body: Center(
            child: Column(
          children: [
            Text("${daysOfWeek[DateTime.parse(date).weekday]}"),
            Text(time),
            const Text(""),
            Text(content)
          ],
        )));
  }
}
