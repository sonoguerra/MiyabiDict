import 'package:flutter/material.dart';
import 'package:pwa_dict/wordpage.dart';
import 'firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';
import 'entry.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var displayed = Vocabulary.fromJson(jsonDecode('{"id":"1151200","kanji":[{"common":false,"text":"茜","tags":[]}],"kana":[{"common":false,"text":"あかね","tags":[],"appliesToKanji":["*"]},{"common":false,"text":"アカネ","tags":[],"appliesToKanji":[]}],"sense":[{"partOfSpeech":["n"],"appliesToKanji":["*"],"appliesToKana":["*"],"related":[],"antonym":[],"field":[],"dialect":[],"misc":["uk"],"info":[],"languageSource":[],"gloss":[{"lang":"eng","gender":null,"type":null,"text":"madder (esp. Japanese madder, Rubia argyi)"}]},{"partOfSpeech":["n"],"appliesToKanji":["*"],"appliesToKana":["*"],"related":[],"antonym":[],"field":[],"dialect":[],"misc":[],"info":[],"languageSource":[],"gloss":[{"lang":"eng","gender":null,"type":null,"text":"madder (red color)"}]}]}'));
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: WordPage(displayed: displayed)),
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
