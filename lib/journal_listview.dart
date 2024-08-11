import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'journal_content.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DisplayData extends StatelessWidget {
  DisplayData({super.key});

  String _date = "";
  String _time = "";

  getDateTime(Timestamp datetime){
    DateTime dateTime = datetime.toDate();
    _date = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    _time = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
    return [_date, _time];
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String? userEmail = _auth.currentUser?.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Data'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('JournalEntries').where('userEmail', isEqualTo: userEmail).snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData){
              return ListView.builder(itemBuilder: (context, index){
                var data = snapshot.data!.docs[index];
                var dateTime = getDateTime(data["datetime"]);
                _date = dateTime[0];
                _time = dateTime[1];
                
                return ListTile(
                  leading: CircleAvatar(
                    child: Text("${index+1}"),
                  ),
                  
                  title: Text(_date),
                  subtitle: Text(_time),
                  onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Display_Journal_Data(
                            
                            date: getDateTime(snapshot.data!.docs[index]["datetime"])[0],
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
            } 
            else if(snapshot.hasError){
              return Center(child: Text(snapshot.hasError.toString()));
            }
            else{
              return const Center(child: Text("Not Data Found"),);
            }
          }
          else{
            return const Center(child: CircularProgressIndicator());
          }
        }),

    );
  }
}