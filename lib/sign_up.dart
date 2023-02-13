// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase/componats/alert.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignPage extends StatelessWidget {
  SignPage({super.key});

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late String userName, email, password;
  late UserCredential userCredential;

  @override
  Widget build(BuildContext context) {
    signUp() async {
      showLoading(context);
      var formData = formState.currentState;
      if (formData!.validate()) {
        formData.save();
        try {
          userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          return userCredential;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Navigator.of(context).pop();
           AwesomeDialog(
                context: context,
                title: "Error",
                body: const Text('The password provided is too weak\n')
                ).show();
          } else if (e.code == 'email-already-in-use') {
            Navigator.of(context).pop();
             AwesomeDialog(
                context: context,
                title: "Error",
                body: const Text('The account already exists for that email\n')
                ).show();
          }
        } catch (e) {
          print(e);
        }
      } else {
        print('Not valid');
      }
    }

    return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                      key: formState,
                      child: Column(
                        children: [
                          TextFormField(
                            onSaved: (newValue) {
                              userName = newValue!;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              label: Text('User name'),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.length > 100) {
                                return 'user name can\'t be greater than 100';
                              }
                              if (value.length < 2) {
                                return 'user name can\'t be lesser than 2';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            onSaved: (newValue) {
                              email = newValue!;
                            },
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                label: Text('E-mail'),
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value!.length > 100) {
                                return 'Email can\'t be greater than 100';
                              }
                              if (value.length < 2) {
                                return 'Email can\'t be lesser than 2';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            onSaved: (newValue) {
                              password = newValue!;
                            },
                            obscureText: true,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                label: Text('Password'),
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value!.length > 100) {
                                return 'Password can\'t be greater than 100';
                              }
                              if (value.length < 4) {
                                return 'Password can\'t be lesser than 4';
                              }
                              return null;
                            },
                          ),
                        ],
                      )),
                  ElevatedButton(
                      onPressed: () async{
                      UserCredential? response= await signUp();
                      print('===========');
                      if(response!=null){
                        await FirebaseFirestore.instance.collection('users').add({
                          'username':userName,
                          'email' :email
                        });
                        Navigator.of(context).pushReplacementNamed('homepage');
                      }
                      print('===========');
                      },
                      child: const Text('Sign Up')),
                  const Text("Do you have an account?"),
                  ElevatedButton(onPressed: () {
                    Navigator.of(context).pushReplacementNamed('sign_in');
                  }, child: const Text('Sign In'))
                ],
              ),
            ),
          )
          );
  }
}
