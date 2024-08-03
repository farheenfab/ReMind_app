import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'calendarDB.dart';
import 'calendarEventList.dart';

class CalendarEvent extends StatefulWidget {
  const CalendarEvent({super.key});

  @override
  State<CalendarEvent> createState() => _CalendarEventState();
}

class _CalendarEventState extends State<CalendarEvent> {
  TextEditingController eventDescription = TextEditingController();
  TextEditingController eventName = TextEditingController();
  TextEditingController eventLocation = TextEditingController();
  TextEditingController eventTime = TextEditingController();


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase connection'),
        leading:
        IconButton(
          onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  CalendarEventViewPage()),
        ), icon: const Icon(Icons.add_circle))
        ,
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            width: 400,
            child: Center(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: eventName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Enter Event Name',
                    ),
                  ),
                  TextField(
                    controller: eventDescription,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Enter Event Description (Optional)',
                    ),
                  ),
                  TextField(
                    controller: eventLocation,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Enter Event Location (Optional)',
                    ),
                  ),
                  TextField(
                    controller: eventTime,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Enter Event Time (Optional)',
                    ),
                  ),
                ],
              )
            ),
          ),
          ElevatedButton(
              child: const Text('Create Event'),
              onPressed: () async {
                await DatabaseService().addData(
                  //_selectedDay.toIso8601String()
                  DateTime.now().toIso8601String(),
                  eventName.text, 
                  eventDescription.text,
                  eventLocation.text,
                  eventTime.text,
                  DateTime.now() 
                  );

                eventName.clear();
                eventDescription.clear();
                eventLocation.clear();
                eventTime.clear();

                // Navigator.of(context).pop();
              },
            ),

          ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () async {
                //  Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}
