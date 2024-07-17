import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // final String entryid;
  // DatabaseService({required this.entryid});
  final CollectionReference journalCollection = FirebaseFirestore.instance.collection('JournalEntry');
  Future addData(String entry, String datetime) async{
    return await journalCollection.doc().set(
      {'entry': entry, 'datetime': datetime}
    );
  }
}
