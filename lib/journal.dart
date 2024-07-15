import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'fetch.dart';

class JournalDiaryEntry extends StatefulWidget {
  const JournalDiaryEntry({super.key});

  @override
  State<JournalDiaryEntry> createState() => _MyJournalEntryState();
}

class _MyJournalEntryState extends State<JournalDiaryEntry> {
  TextEditingController recordController = TextEditingController();

  // late DatabaseReference dbRef;

  @override
  void initState(){
    super.initState();
    // dbRef = FirebaseDatabase.instance.ref().child("JournalEntry");
    // dbRef = FirebaseFirestore.instance.collection('JournalEntry');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase connection'),
        leading:
        IconButton(onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DisplayData()),
        ), icon: const Icon(Icons.add_circle))
        ,
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
                // keyboardType: TextInputType.phone,
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
                // Navigator.pushNamed(context, '/second');
                // Map<String, String> journalEntry = {
                //   'entry': recordController.text
                // };
                // dbRef.push().set(journalEntry);
                // dbRef.add().set(journalEntry); //added

                await DatabaseService().addData(recordController.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
