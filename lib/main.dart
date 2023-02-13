
import 'package:firebase/add_note.dart';
import 'package:firebase/home_page.dart';
import 'package:firebase/sign_in.dart';
import 'package:firebase/sign_up.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


User? user;
bool isLogin = true;
Future backgroundMessaging(RemoteMessage message)async{
  print('=========================');
  print('${message.notification?.body}');
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundMessaging);
  user = FirebaseAuth.instance.currentUser;
  if (user == null){
    isLogin=false;
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogin?const HomePage(): const SignInPage(),
      routes: {
        "homepage":(context)=>const HomePage(),
        "sign_in" :(context) => const SignInPage(),
        "sign_up" :(context) =>  SignPage(),
        "add_note":(context) => const AddNotes(),
      }
    );
  }
}



