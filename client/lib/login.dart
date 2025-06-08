import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register.dart';

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
      backgroundColor: Color.fromARGB(255, 171, 231, 231),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: 530,
          height: 600.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(31.0),
          ),
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 25.0,
              children: [
                Text("Login", style: TextStyle(fontSize: 35.0)),



                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                  obscureText: true,
                  controller: password,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email.text,
                        password: password.text,
                      );
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'wrong-password') {
                        if (context.mounted) {
                          //Function block is async so this has to be checked.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Wrong password.")),
                          );
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
                  label: Text('Login', style: TextStyle(fontSize: 21.0)),
                  icon: const Icon(Icons.key),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New user?", style: TextStyle(fontSize: 12.0)),
                    TextButton(
                      child: Text("Register."),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));
                      },
                    ),
                  ],
                ),
                Text("or"),
                ElevatedButton.icon(
                  label: Text("Login as guest"),
                  icon: Icon(Icons.person),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInAnonymously();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    } on FirebaseAuthException catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error.")));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
