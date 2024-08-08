import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'home_page.dart';
import 'calanderEvent.dart';
import 'calendarEventList.dart'; // Import the CalendarEventViewPage
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

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
      final date = DateTime.parse(map['date']).toLocal();
      final event = map['event'] as String;

      if (loadedEvents[date] == null) {
        loadedEvents[date] = [];
      }
      loadedEvents[date]!.add(event);
    }

    setState(() {
      _events = loadedEvents;
      _selectedEvents = _events[_selectedDay] ?? [];
    });

    print('Loaded events: $_events'); // Debug line
  }

  Future<void> _addEvent(String event) async {
    final date = _selectedDay.toIso8601String();
    await _database.insert('events', {'date': date, 'event': event});
    if (_events[_selectedDay] == null) {
      _events[_selectedDay] = [];
    }
    _events[_selectedDay]!.add(event);
    setState(() {
      _selectedEvents = _events[_selectedDay]!;
    });

    print('Added event: $event on $_selectedDay');
    print('Events: $_events');
  }

  Future<void> _removeEvent(String event) async {
    final date = _selectedDay.toIso8601String();
    await _database.delete(
      'events',
      where: 'date = ? AND event = ?',
      whereArgs: [date, event],
    );
    _events[_selectedDay]?.remove(event);

    // Reload events to reflect changes
    await _loadEvents();

    // Update the selected events after reloading
    setState(() {
      _selectedEvents = _events[_selectedDay] ?? [];
    });

    print('Removed event: $event from $_selectedDay');
    print('Events: $_events');
  }

  Future<bool> _checkIfDateHasEvents(DateTime date) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('CalendarEvent')
        .where('eventDate', isEqualTo: date.toIso8601String())
        .limit(1) // Limit to 1 to check existence
        .get();

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CalendarEventViewPage(
            selectedDay: selectedDay, // Pass the selected date
          ),
        ),
      );
    } else {
      // Show a message or handle no events case
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //       content: Text(
      //           'No events found for ${selectedDay.toLocal().toString().split(' ')[0]}')),
      // );
    }
  }

  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(
                  username: 'John',
                ),
              ),
            );
          },
        ),
        title: Text('Calendar', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 3.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.all(16.0),
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
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    eventLoader: (day) => _events[day.toLocal()] ?? [],
                    onDaySelected: _onDaySelected,
                    calendarFormat: _calendarFormat,
                    onFormatChanged: _onFormatChanged,
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      defaultTextStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      weekendTextStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      selectedTextStyle: TextStyle(color: Colors.black),
                      selectedDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2.0),
                        color: isSameDay(_selectedDay, _focusedDay)
                            ? Colors.white
                            : Colors.transparent,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        if (events.isEmpty) {
                          return SizedBox.shrink();
                        }

                        return Positioned(
                          bottom: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(events.length, (index) {
                              return Container(
                                width: 6,
                                height: 6,
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        2), // Increased margin for visibility
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  shape: BoxShape.circle,
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ..._selectedEvents.map((event) => ListTile(
                        title: Text(event),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _removeEvent(event),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: const Color(0xFF382973),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarEvent(
                    selectedDate: _selectedDay, // Pass the selected date
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
