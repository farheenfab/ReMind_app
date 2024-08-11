import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // final String entryid;
  // DatabaseService({required this.entryid});
  final CollectionReference journalCollection =
      FirebaseFirestore.instance.collection('JournalEntries');
  Future addData(String entry, DateTime datetime, String userEmail) async {
    return await journalCollection
        .doc()
        .set({'entry': entry, 'datetime': datetime, "userEmail": userEmail});
  }
}
