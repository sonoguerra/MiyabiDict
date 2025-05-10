import 'package:flutter/material.dart';
import 'package:pwa_dict/wordpage.dart';
import 'firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';
import 'entry.dart';
import 'database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var displayed = await Database.search("きんもくせい");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: WordPage(displayed: displayed[0])),
  );
}

/*
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}*/
