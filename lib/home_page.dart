// import 'package:flutter/material.dart';
// import 'profile_page.dart';
// import 'settings.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class HomePage extends StatefulWidget {
//   final String username;

//   const HomePage({Key? key, required this.username}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _currentIndex = 0;

//   final List<Widget> _children = [
//     PlaceholderWidget(),
//     PlaceholderWidget(),
//     PlaceholderWidget(),
//     PlaceholderWidget(),
//     SettingsPage(),
//   ];

//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//     if (index == 4) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SettingsPage(),
//         ),
//       ).then((_) {
//         setState(() {
//           _currentIndex = 0;
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_currentIndex != 0) {
//           setState(() {
//             _currentIndex = 0;
//           });
//           return false;
//         }
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: const Text('Home'),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.person),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProfileDetailsPage(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(20.0),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF382973),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Hello, ${widget.username}',
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   children: <Widget>[
//                     HomeButton(
//                       icon: Icons.calendar_today,
//                       label: 'Calendar',
//                       onTap: () {
//                         // Handle Calendar button tap
//                       },
//                       color: Colors.green,
//                     ),
//                     HomeButton(
//                       icon: Icons.medical_services,
//                       label: 'Medication',
//                       onTap: () {
//                         // Handle Medication button tap
//                       },
//                       color: Colors.yellow,
//                     ),
//                     HomeButton(
//                       icon: Icons.chat,
//                       label: 'Let\'s Chat',
//                       onTap: () {
//                         // Handle Let's Chat button tap
//                       },
//                       color: Colors.blue,
//                     ),
//                     HomeButton(
//                       icon: Icons.warning,
//                       label: 'SOS',
//                       onTap: () {
//                         // Handle SOS button tap
//                       },
//                       color: Colors.red,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.games),
//               label: 'Games',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.mic),
//               label: 'Microphone',
//             ),
//             BottomNavigationBarItem(
//               icon: FaIcon(FontAwesomeIcons.brain),
//               label: 'Memory Log',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.settings),
//               label: 'Settings',
//             ),
//           ],
//           currentIndex: _currentIndex,
//           selectedItemColor: const Color(0xFF382973),
//           unselectedItemColor: Colors.black,
//           onTap: onTabTapped,
//         ),
//       ),
//     );
//   }
// }

// class PlaceholderWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Placeholder Widget'),
//     );
//   }
// }

// class HomeButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//   final Color color;

//   const HomeButton({
//     Key? key,
//     required this.icon,
//     required this.label,
//     required this.onTap,
//     required this.color,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         color: color,
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 icon,
//                 size: 40,
//                 color: Colors.white,
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'profile_page.dart';
import 'settings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'calender_page.dart';
import 'chat_page.dart';
import 'medication_page.dart';
import 'sos_page.dart';
import 'games_page.dart';
import 'memory_log_page.dart';

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
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MemoryLogPage()),
      );
    } else if (index == 4) {
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
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final String formattedTime = DateFormat('HH:mm').format(now);

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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                constraints: BoxConstraints(
                  minWidth: 500, // Minimum width
                  minHeight: 150, // Minimum height
                  maxWidth: 900, // Maximum width
                  maxHeight: 150, // Maximum height
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF382973),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'Hello, ${widget.username} !',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date: $formattedDate',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Time: $formattedTime',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
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
                        // Handle Calendar button tap
                      },
                      color: Colors.green,
                      iconSize: 50,
                      fontSize: 18,
                    ),
                    HomeButton(
                      icon: Icons.medical_services,
                      label: 'Medication',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedicationPage(),
                          ),
                        );
                        // Handle Medication button tap
                      },
                      color: Color.fromARGB(255, 255, 235, 52),
                      iconSize: 50,
                      fontSize: 18,
                    ),
                    HomeButton(
                      icon: Icons.chat,
                      label: 'Let\'s Chat',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(), // Navigate to ChatPage
                          ),
                        );
                      },
                      // Handle Let's Chat button ta
                      color: Colors.blue,
                      iconSize: 50,
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
                        // Handle SOS button tap
                      },
                      color: Colors.red,
                      iconSize: 50,
                      fontSize: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.black, width: 1.0),
            ),
          ),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.games),
                label: 'Games',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mic),
                label: 'Microphone',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.brain),
                label: 'Memory Log',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: const Color(0xFF382973),
            unselectedItemColor: Colors.black,
            onTap: onTabTapped,
          ),
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

  final double iconSize;
  final double fontSize;

  const HomeButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
    required this.iconSize,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
