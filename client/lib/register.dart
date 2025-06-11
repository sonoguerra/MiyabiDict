import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final repeatPassword = TextEditingController();
  bool wrongEmail = false;
  bool badPassword = false;
  bool alreadyEmail = false;
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


                Text("Register", style: TextStyle(fontSize: 35.0)),
                TextFormField(
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  validator: (value) {
                    if (wrongEmail) {
                      return "Invalid email.";
                    }
                    else if (alreadyEmail) {
                      return "User with the supplied email already exists.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  controller: password,
                  validator: (value) {
                    if (badPassword) {
                      return "Password too weak.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  controller: repeatPassword,
                  validator: (value) {
                    if (value != password.text) {
                      return "Passwords not matching.";
                    }
                    return null;
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    setState(() {
                      wrongEmail = false;
                      badPassword = false;
                      alreadyEmail = false;
                    });
                    try {
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email.text,
                        password: password.text,
                      );
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        setState(() {
                          badPassword = true;
                        });
                      } else if (e.code == 'email-already-in-use') {
                        setState(() {
                          alreadyEmail = true;
                        });
                      } else if (e.code == 'invalid-email') {
                        setState(() {
                          wrongEmail = true;
                        });
                      }
                      else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something unexpected happened. Try again later.")));
                        }
                      }
                    }
                    key.currentState!.validate();
                  },
                  label: Text('Register', style: TextStyle(fontSize: 21.0)),
                  icon: const Icon(Icons.key),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already registered?", style: TextStyle(fontSize: 12.0)),
                    TextButton(
                      child: Text("Login."),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}