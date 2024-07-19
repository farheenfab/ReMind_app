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
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _selectedDay,
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
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 16),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
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
        title: Text('Add Event'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter event',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final event = controller.text;
              if (event.isNotEmpty) {
                _addEvent(event);
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
