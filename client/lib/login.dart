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
  bool wrongEmail = false;
  bool wrongPassword = false;
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
      backgroundColor: Theme.of(context).primaryColor,
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
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  validator: (value) {
                    if (wrongEmail) {
                      return "User with the supplied email does not exist.";
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
                    if (wrongPassword) {
                      return "Wrong password";
                    }
                    return null;
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    setState(() {
                      wrongPassword = false;
                      wrongEmail = false;
                    });
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email.text,
                        password: password.text,
                      );
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
                        setState(() {
                          wrongPassword = true;
                        });
                      } else if (e.code == 'user-disabled' || e.code == 'invalid-email' || e.code == 'user-not-found') {
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
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
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Error. ${e.code}")));
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
