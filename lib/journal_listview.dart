import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'journal_content.dart';
import 'bottom_navigation.dart'; // Ensure this import is correct
import 'home_page.dart';
import 'settings.dart';
import 'memory_game.dart';
import 'games_selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DisplayData extends StatefulWidget {
  @override
  _DisplayDataState createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  int _currentIndex = 0; // Manage navigation bar index

  String _date = "";
  String _time = "";

  getDateTime(Timestamp datetime) {
    DateTime dateTime = datetime.toDate();
    _date =
        "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    _time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
    return [_date, _time];
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String? userEmail = _auth.currentUser?.email;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
            255, 41, 19, 76), // Dark purple background color
        title: const Align(
          alignment: Alignment.centerLeft, // Align the title to the left
          child: Text(
            'Memory Log',
            style: TextStyle(color: Colors.white), // White title color
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white, // White back arrow color
        ),
      ),
      body: Container(
        color: Colors.white, // Set the background color to white
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('JournalEntries')
              .where('userEmail', isEqualTo: userEmail)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    var dateTime = getDateTime(data["datetime"]);
                    _date = dateTime[0];
                    _time = dateTime[1];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color.fromARGB(
                            255, 41, 19, 76), // Dark purple color
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            color:
                                Colors.white, // White text color for contrast
                          ),
                        ),
                      ),
                      title: Text(_date),
                      subtitle: Text(_time),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Display_Journal_Data(
                              date: getDateTime(
                                  snapshot.data!.docs[index]["datetime"])[0],
                              time: _time,
                              content: snapshot.data!.docs[index]["entry"],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.hasError.toString()));
              } else {
                return const Center(
                  child: Text("No Data Found"),
                );
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          // Define your navigation logic here
          if (index != 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  switch (index) {
                    case 0:
                      return HomePage(); // Replace 'User' with actual username if needed
                    case 1:
                      return GamesSelectionScreen();
                    case 2:
                      return DisplayData();
                    case 3:
                      return SettingsPage();
                    default:
                      return SettingsPage();
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
