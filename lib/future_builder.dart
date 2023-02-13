import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Test3 extends StatefulWidget {
  const Test3({super.key});

  @override
  State<Test3> createState() => _Test3State();
}

class _Test3State extends State<Test3> {
  CollectionReference usersref = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Future Builder'),
      ),
      body: FutureBuilder(
        future:usersref.get() ,
        builder:(context,snapshot){
          if(snapshot.hasData){
            return  ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder:(context,index){
                return ListTile(
                  title: Text('username: ${snapshot.data?.docs[index]['username']}'),
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
          
          return Text('');
        } , 
        ),
    );
  }
}