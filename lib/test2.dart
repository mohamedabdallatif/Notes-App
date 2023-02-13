// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Test2 extends StatefulWidget {
  const Test2({super.key});

  @override
  State<Test2> createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  List users=[];
  CollectionReference usersref = FirebaseFirestore.instance.collection('users');
  getData()async{
    var responseBody =await usersref.get();
    responseBody.docs.forEach((element) {
      setState(() {
         users.add(element.data()); 
      });
    });
      print(users);
  }
  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body:users.isEmpty?const Center(child: CircularProgressIndicator(),):
       ListView.builder(
        itemCount: users.length,
        itemBuilder: (context,index){
          return ListTile(
            title: Text('username: ${users[index]['username']}'),
            subtitle: Text('phone: ${users[index]['phone']}'),
          );
      }),
    );
  }
}