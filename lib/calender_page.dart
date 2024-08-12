import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'home_page.dart';
import 'calanderEvent.dart';
import 'calendarEventList.dart'; // Import the CalendarEventViewPage
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'global_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Database _database;
  Map<DateTime, List<String>> _events = {};
  List<String> _selectedEvents = [];
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'events.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE events(id INTEGER PRIMARY KEY, date TEXT, event TEXT)',
        );
      },
    );

    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final List<Map<String, dynamic>> maps = await _database.query('events');
    final Map<DateTime, List<String>> loadedEvents = {};

    for (var map in maps) {
      // final date = DateTime.parse(map['date']).toLocal();
      DateTime convertedDate = DateTime.parse(map['date']);
      final event = map['event'] as String;

      if (loadedEvents[convertedDate] == null) {
        //date
        loadedEvents[convertedDate] = []; //date
      }
      loadedEvents[convertedDate]!.add(event); //date
    }

    setState(() {
      _events = loadedEvents;
      _selectedEvents = _events[_selectedDay] ?? [];
    });

    // Debug: Print loaded events
    print('---------------------------------------------------');
    print('Loaded events: $_events');
    print('Loaded events: $_selectedDay');
  }

  Future<void> _addEvent(String event) async {
    final date = _selectedDay.toIso8601String();
    print('hiiiii');
    print(date);
    await _database.insert('events', {'date': _selectedDay, 'event': event});
    if (_events[date] == null) {
      _events[_selectedDay] = [];
    }
    _events[date]!.add(event);
    setState(() {
      _selectedEvents = _events[date]!;
    });

    print('---------------------------------------------------');
    print('Loaded events: $_events');
    print('Loaded events: $_selectedDay');
  }

  Future<void> _removeEvent(String event) async {
    final date = _selectedDay.toIso8601String();
    await _database.delete(
      'events',
      where: 'date = ? AND event = ?',
      whereArgs: [date, event],
    );
    _events[date]?.remove(event);

    // Reload events to reflect changes
    await _loadEvents();

    // Update the selected events after reloading
    setState(() {
      _selectedEvents = _events[date] ?? [];
    });

    print('Removed event: $event from $_selectedDay');
    print('Events: $_events');
  }

  Future<bool> _checkIfDateHasEvents(DateTime date) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('CalendarEvents')
        .where('eventDate', isEqualTo: date.toIso8601String())
        .where('userEmail', isEqualTo: userEmail.toString())
        .limit(1) // Limit to 1 to check existence
        .get();

    // Debug: Print Firestore check result
    print('Firestore Check: ${snapshot.docs.isNotEmpty}');

    return snapshot.docs.isNotEmpty;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents = _events[selectedDay] ?? [];
    });

    final hasEvents = await _checkIfDateHasEvents(selectedDay);

    if (hasEvents) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: -10,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Center(
                  child: Text(
                    'Event list',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: CalendarEventViewPage(
                selectedDay: selectedDay,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  backgroundColor: const Color.fromARGB(255, 41, 19, 76),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalendarEvent(
                          selectedDate: selectedDay,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    } else {
      // _showNoEventsDialog(context, selectedDay);
    }
  }

  // Function to show a dialog when no events are found
  // void _showNoEventsDialog(BuildContext context, DateTime selectedDay) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('No Events'),
  //         content: Text(
  //             'No events found for ${selectedDay.toLocal().toString().split(' ')[0]}.'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    // final String?
    userEmail = _auth.currentUser?.email;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 41, 19, 76),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
        title: Text('Calendar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 3.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.all(20.0),
              height: 600,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 238, 232, 250),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    rowHeight: 80,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    eventLoader: (day) {
                      final normalizedDay =
                          DateTime(day.year, day.month, day.day);
                      final events = _events[normalizedDay] ?? [];

                      // Debug: Print the day and associated events
                      print('Date: $normalizedDay, Events: $events');

                      return events;
                    },
                    onDaySelected: _onDaySelected,
                    calendarFormat: _calendarFormat,
                    onFormatChanged: _onFormatChanged,
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      defaultTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      weekendTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      selectedTextStyle: TextStyle(color: Colors.black),
                      todayDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(
                            255, 41, 19, 76), // Change to your desired color
                      ),
                      selectedDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2.0),
                        color: isSameDay(_selectedDay, _focusedDay)
                            ? Color.fromARGB(255, 255, 255, 255)
                            : Colors.transparent,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      titleTextStyle: TextStyle(
                        fontSize: 20, // Set your desired font size
                        fontWeight: FontWeight.bold, // Make the text bold
                      ),
                      formatButtonVisible:
                          false, // Hide the format button if not needed
                      leftChevronIcon:
                          Icon(Icons.chevron_left, color: Colors.black),
                      rightChevronIcon:
                          Icon(Icons.chevron_right, color: Colors.black),
                      titleCentered: true, // Centers the title text
                    ),
                    // Remove the markerBuilder to eliminate red dots
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        if (events.isNotEmpty) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              width: 6.0,
                              height: 6.0,
                              decoration: BoxDecoration(
                                color:
                                    Colors.red, // Change to your desired color
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_selectedEvents.isNotEmpty)
                    ..._selectedEvents.map(
                      (event) => Container(
                        margin: EdgeInsets.only(bottom: 8.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 233, 215, 235),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                event,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.black),
                              onPressed: () => _removeEvent(event),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 10), // Adjust the height as needed
            Expanded(child: Container()), // Space filler
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 41, 19, 76),
        onPressed: () {
          print(_selectedDay);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CalendarEvent(
                selectedDate: _selectedDay,
              ),
            ),
          );
        },
      ),
    );
  }
}
