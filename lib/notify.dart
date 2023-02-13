
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class Notify extends StatefulWidget {
  const Notify({super.key});

  @override
  State<Notify> createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  var serverToken = 'AAAAKatU8Ng:APA91bFxY8Qyq8JGT1CyGZ55wkGsLHRUj_zrTfu85hBWV6yOulmzRQGBlvI3D7Qvxp3-B-J3eaChO8EZE-Elc5KjUHkKmaylN7ZIdpohT8YUhaSFkIT8iORcg3i7bMAiwxx2_YJvdltv';
  sendNotification(String title,String body) async {
   await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
     headers: <String, String>{
       'Content-Type': 'application/json',
       'Authorization': 'key=$serverToken',
     },
     body: jsonEncode(
     <String, dynamic>{
       'notification': <String, dynamic>{
         'body': 'this is a body',
         'title': 'this is a title'
       },
       'priority': 'high',
       'data': <String, dynamic>{
         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
         'id': '1',
         'status': 'done'
       },
       'to': '/topic/tifa',
     },
    ),
  );
}
getMessage(){
  FirebaseMessaging.onMessage.listen((event) {
    print('==============================');
    print(event.notification?.title);

  });
}
@override
  void initState() {
    getMessage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('notifications page')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed:() async {
                 await sendNotification('mooooo','tifaaaaaaaaaa');
              },
              child: const Text('Send Notification'),
            ),
            ElevatedButton(
          onPressed:()async{
            await FirebaseMessaging.instance.subscribeToTopic('tifa');
          } ,
          child: const Text('Subscribe token'),
        ),
        ElevatedButton(
          onPressed:()async{
            await FirebaseMessaging.instance.unsubscribeFromTopic('tifa');
          },
          child: const Text('Unsubscribe token'),
        ),
          ],
        ),
      ),
    );
  }
}

