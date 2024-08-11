import 'package:alz_app/calendarEventList.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_page.dart';
import 'settings.dart';
import 'calender_page.dart';
import 'chat_screen.dart';
import 'Screen/medicineView.dart';
import 'Screen/sos.dart';
import 'games_selection_screen.dart';
import 'memory_log_page.dart';
import 'journal_listview.dart';
import 'bottom_navigation.dart';
import 'calendarEventList.dart'; // Updated import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  // final String username;

  const HomePage({
    Key? key,
    // required this.username
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Map<String, dynamic>? patientData;
  String username = "";

  void onTabTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GamesSelectionScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DisplayData()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage()),
      ).then((_) {
        setState(() {
          _currentIndex = 0;
        });
      });
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final email = user.email;

      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('Patients')
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final data = querySnapshot.docs.first.data() as Map<String, dynamic>;
          setState(() {
            patientData = data;
            username = data['name'] ?? '';
          });
        }
      } catch (e) {
        print('Error fetching patient details: $e');
      }
    } else {
      print('No user is logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime startOfDay = DateTime(today.year, today.month, today.day);
    DateTime endOfDay =
        DateTime(today.year, today.month, today.day, 23, 59, 59);

    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 41, 19, 76),
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileDetailsPage(),
                  ),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(
              height: 1.0,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  minWidth: 500,
                  minHeight: 50,
                  maxWidth: 900,
                  maxHeight: 50,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hello, ${username}!',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 41, 19, 76),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: <Widget>[
                    HomeButton(
                      icon: Icons.calendar_today,
                      label: 'Calendar',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CalendarPage(),
                          ),
                        );
                      },
                      color: Color.fromARGB(255, 180, 224, 173),
                      iconColor: Color.fromARGB(255, 0, 100, 0),
                      iconSize: 60,
                      fontSize: 18,
                    ),
                    HomeButton(
                      icon: Icons.medical_services,
                      label: 'Medication',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedicineViewPage(),
                          ),
                        );
                      },
                      color: Color.fromARGB(255, 252, 233, 156),
                      iconColor: Color.fromARGB(255, 223, 180, 39),
                      iconSize: 60,
                      fontSize: 18,
                    ),
                    HomeButton(
                      icon: Icons.chat,
                      label: 'Let\'s Chat',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              voice: const {
                                "name": "en-us-x-tpf-local",
                                "locale": "en-US"
                              },
                              volume: 1.0,
                              pitch: 1.0,
                              speechRate: 0.5,
                            ),
                          ),
                        );
                      },
                      color: Color.fromARGB(255, 168, 213, 250),
                      iconColor: const Color.fromARGB(255, 30, 110, 175),
                      iconSize: 60,
                      fontSize: 18,
                    ),
                    HomeButton(
                      icon: Icons.warning,
                      label: 'SOS',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SOSPage(),
                          ),
                        );
                      },
                      color: Color.fromARGB(255, 255, 174, 174),
                      iconColor: Color.fromARGB(255, 222, 38, 5),
                      iconSize: 60,
                      fontSize: 18,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(15.0),
                constraints: BoxConstraints(
                  minWidth: 500,
                  minHeight: 100,
                  maxWidth: 900,
                  maxHeight: 190,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 231, 217, 252),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tasks For The Day',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('CalendarEvents')
                              .where('eventDate',
                                  isGreaterThanOrEqualTo:
                                      startOfDay.toIso8601String())
                              .where('eventDate',
                                  isLessThanOrEqualTo:
                                      endOfDay.toIso8601String())
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Center(
                                  child: Text('No tasks for today.'));
                            }

                            final events = snapshot.data!.docs;

                            return ListView.builder(
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                var event = events[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical:
                                          2.0), // Reduced vertical padding
                                  child: Text(
                                    '${index + 1}. ${event['eventName']}',
                                    style: const TextStyle(fontSize: 16), //
                                  ),
                                );
                              },
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color iconColor;
  final double iconSize;
  final double fontSize;

  const HomeButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
    required this.iconColor,
    this.iconSize = 50,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
