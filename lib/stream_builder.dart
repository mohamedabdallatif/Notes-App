import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Test4 extends StatefulWidget {
  const Test4({super.key});

  @override
  State<Test4> createState() => _Test4State();
}

class _Test4State extends State<Test4> {
  CollectionReference notesref = FirebaseFirestore.instance.collection('notes');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stream Builder'),
      ),
      body: StreamBuilder(
        stream:notesref.snapshots() ,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder:(context,i){
                return ListTile(
              title: Text(snapshot.data?.docs[i]['body']),
            );
              } );
          }
          if(snapshot.hasError){
            return const Text('Error');
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Text('');
        },
        ),
    );
  }
}