import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'journal_listview.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'memory_log_page.dart';

class JournalDiaryEntry extends StatefulWidget {
  const JournalDiaryEntry({super.key});

  @override
  State<JournalDiaryEntry> createState() => _MyJournalEntryState();
}

class _MyJournalEntryState extends State<JournalDiaryEntry> {
  TextEditingController recordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String? userEmail = _auth.currentUser?.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase connection'),
        leading: IconButton(
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisplayData()),
                ),
            icon: const Icon(Icons.add_circle)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            width: 400,
            child: Center(
              child: TextField(
                controller: recordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: 'Enter your message here',
                ),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('Push to Firebase!'),
              onPressed: () async {
                await DatabaseService().addData(recordController.text,
                    DateTime.now(), userEmail.toString());
                recordController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
