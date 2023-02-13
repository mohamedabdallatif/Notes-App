// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  getData()async{
   FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
    for (var element in event.docs) {
      print('username:${element.data()['username']}');
      print('email:${element.data()['email']}');
       print('name:${element.data()['age']}');
       print('===========================');
    }
   });
  }
  addData()async{
   CollectionReference usersref= FirebaseFirestore.instance.collection('users');
  /*  usersref.add({
    'username':'tifa',
    'email':'tifa@gmail.com',
    'age':24
   }); */
   /* usersref.doc('30mo').set({
    'username':'mooo',
    'email':'moooo@gmail.com',
    'age':30
   }); */
   /* usersref.doc('30mo').update({
    'age':35
   }); */
   usersref.doc('30moh').update({
    'age':54,
   },).then((value) => print('Update success'))
   .catchError((e)=>print('Update failed'));
  }
  DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc('30mo');
  
  trans ()async{
    FirebaseFirestore.instance.runTransaction((transaction)async {
      DocumentSnapshot docsnap =await transaction.get(userDoc);
      if(docsnap.exists){
        transaction.update(userDoc, {
          'phone':01145545825
        });
      }
      else{
        print('user doesn\'t exsit');
      }
    });
  }
  DocumentReference doc1 = FirebaseFirestore.instance.collection('users').doc('30mo');
  DocumentReference doc2 = FirebaseFirestore.instance.collection('users').doc('oc1QSmTUnMTTVKj5tmA3');
  
  writeBatch(){
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.delete(doc2);
    batch.update(doc1, {
      'age':35
    });
    batch.commit();
  }
  @override
  void initState() {
    writeBatch();
    super.initState();
  }
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}