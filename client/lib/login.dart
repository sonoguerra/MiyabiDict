import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Email"), keyboardType: TextInputType.emailAddress, controller: email),
          TextField(decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Password"), obscureText: true, controller: password),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'wrong-password') {
                  if (context.mounted) { //Function block is async so this has to be checked.
                    ScaffoldMessenger.of(
                      context,


                    ).showSnackBar(SnackBar(content: Text("Wrong password.")));
                  }
                } else if (e.code == 'user-not-found') {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "User with the supplied email does not exist.",
                        ),
                      ),
                    );
                  }
                }
              }
            },
            label: Text('Sign in', style: TextStyle(fontSize: 21.0)),
            icon: const Icon(Icons.key),
          ),
        ],
      ),
    );
  }
}
