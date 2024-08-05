// home.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'profile_page.dart';
import 'settings.dart';
import 'calender_page.dart';
import 'chat_page.dart';
import 'medication_page.dart';
import 'Screen/medicineView.dart';
import 'Screen/sos.dart';
import 'games_page.dart';
import 'memory_log_page.dart';
import 'bottom_navigation.dart'; // Import the new bottom navigation bar

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({Key? key, required this.username}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    PlaceholderWidget(),
    PlaceholderWidget(),
    PlaceholderWidget(),
    PlaceholderWidget(),
    SettingsPage(),
    GamesPage(),
    MemoryLogPage()
  ];

  void onTabTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GamesPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MemoryLogPage()),
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
  Widget build(BuildContext context) {
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
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.person),
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
                  maxHeight: 70,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 41, 19, 76),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hello, ${widget.username}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                      iconColor: Color.fromARGB(255, 0, 100, 0), // Dark green
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
                      iconColor: Color.fromARGB(255, 223, 180,
                          39), // Custom color for medication icon
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
                            builder: (context) => ChatPage(),
                          ),
                        );
                      },
                      color: Color.fromARGB(255, 168, 213, 250),
                      iconColor: const Color.fromARGB(
                          255, 30, 110, 175), // Custom color for chat icon
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
                      iconColor: Color.fromARGB(
                          255, 222, 38, 5), // Custom color for SOS icon
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
                  maxHeight: 170,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 41, 19, 76),
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
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: ListView(
                        children: List.generate(
                          10,
                          (index) => Text(
                            'Task ${index + 1}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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

class PlaceholderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Placeholder Widget'),
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
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
            const SizedBox(height: 8.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
