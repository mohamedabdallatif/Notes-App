import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase/componats/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formState = GlobalKey<FormState>();
    late String email, password;
    late UserCredential userCredential;

    signIn() async {
      var formData = formState.currentState;
      formData?.save();
      if (formData!.validate()) {
        try {
          showLoading(context);
           userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: email, 
                  password: password);
                  return userCredential;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            Navigator.of(context).pop();
             AwesomeDialog(
                context: context,
                title: "Error",
                body: const Text('No user found for that email\n')
                ).show();
          } else if (e.code == 'wrong-password') {
            Navigator.of(context).pop();
             AwesomeDialog(
                context: context,
                title: "Error",
                body: const Text('Wrong password provided for that user\n')
                ).show();
          }
        }
      } else {
        print('Not Valid');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset('assets/images/logo.png'),
                const SizedBox(
                  height: 10,
                ),
                Form(
                    key: formState,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              label: Text('Email'),
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
                          onSaved: (newValue) {
                            email = newValue!;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              label: Text('Password'),
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value!.length > 100) {
                              return 'Password can\'t be greater than 100';
                            }
                            if (value.length < 2) {
                              return 'Password can\'t be lesser than 2';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            password = newValue!;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              UserCredential? user = await signIn();
                              if(user!=null){
                                Navigator.of(context).pushReplacementNamed('homepage');
                              }
                            },
                            child: const Text('Sign In')),
                        const Text('Don\'t have an account?'),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('sign_up');
                            },
                            child: const Text('Create New account')
                            )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
