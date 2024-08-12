import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference journalCollection =
      FirebaseFirestore.instance.collection('CalendarEvents');
  Future addData(
      String eventDate,
      String eventName,
      String eventDescription,
      String eventLocation,
      String eventTime,
      DateTime eventTimestamp,
      String userEmail) async {
    return await journalCollection.doc().set({
      'eventDate': eventDate,
      'eventDescription': eventDescription,
      'eventName': eventName,
      'eventLocation': eventLocation,
      'eventTime': eventTime,
      'eventTimestamp': eventTimestamp,
      'userEmail': userEmail
    });
  }
}
