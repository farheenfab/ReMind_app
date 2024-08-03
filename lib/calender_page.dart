import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

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
      final date = DateTime.parse(map['date']);
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

    print('Loaded events: $_events');
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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents = _events[selectedDay] ?? [];
    });
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
        title: Text('Calendar'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 3.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // White background for the entire page
        child: Column(
          children: [
            Container(
              color: Colors.white, // Ensure background color is white
              child: Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    eventLoader: (day) {
                      return _events[day] ?? [];
                    },
                    onDaySelected: _onDaySelected,
                    calendarFormat: _calendarFormat,
                    onFormatChanged: _onFormatChanged,
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      defaultTextStyle: TextStyle(color: Colors.black),
                      weekendTextStyle: TextStyle(color: Colors.black),
                      selectedTextStyle: TextStyle(
                        color: Colors.black,
                      ),
                      selectedDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        color: isSameDay(_selectedDay, DateTime.now())
                            ? Colors.transparent
                            : Colors.transparent,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 190, 180, 227),
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: true,
                      titleTextStyle:
                          TextStyle(color: Colors.black, fontSize: 16),
                      leftChevronIcon: Icon(Icons.chevron_left,
                          color: Color.fromARGB(255, 174, 161, 226)),
                      rightChevronIcon: Icon(Icons.chevron_right,
                          color: const Color(0xFF382973)),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 1.0, // Black line under the title
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                children: _selectedEvents
                    .map((event) => ListTile(
                          title: Text(event),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,
            color: Colors
                .white), // Ensure the icon is visible with the button color
        backgroundColor: const Color(0xFF382973), // Button color
        onPressed: () {
          _showAddEventDialog();
        },
      ),
    );
  }

  void _showAddEventDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            const Color(0xFF382973), // Background color of the dialog
        title: Text(
          'Add Event',
          style: TextStyle(color: Colors.white), // Title text color
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter event',
            hintStyle: TextStyle(color: Colors.white54), // Hint text color
            border: InputBorder.none, // Remove underline
          ),
          style: TextStyle(color: Colors.white), // Text field input color
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white), // Cancel button text color
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red, // Cancel button background color
            ),
          ),
          TextButton(
            onPressed: () {
              final event = controller.text;
              if (event.isNotEmpty) {
                _addEvent(event);
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Add',
              style: TextStyle(color: Colors.white), // Add button text color
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.green, // Add button background color
            ),
          ),
        ],
      ),
    );
  }
}
