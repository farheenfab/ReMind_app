import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayData extends StatelessWidget {
  const DisplayData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Data'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('JournalEntry').snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData){
              return ListView.builder(itemBuilder: (context, index){
                return ListTile(
                  leading: CircleAvatar(
                    child: Text("${index+1}"),
                  ),
                  title: Text("${snapshot.data!.docs[index]["datetime"]}"),
                  
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