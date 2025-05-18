import 'entry.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:kana_kit/kana_kit.dart';

class WordPage extends StatelessWidget {
  final Vocabulary displayed;
  final _kanaKit = const KanaKit();

  const WordPage({super.key, required this.displayed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Row(
              spacing: 10.0,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.bookmark),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Added to collection.")),
                    );
                  },
                ),
                Text(
                  displayed.word,
                  style: GoogleFonts.shipporiMincho(fontSize: 65.0),
                ),
                Tooltip(
                  message: _kanaKit.toRomaji(displayed.kana[0].text),
                  child: Text(
                    displayed.word == displayed.kana[0].text


                    
                        ? ""
                        : "【${displayed.kana[0].text}】",
                    style: GoogleFonts.shipporiMincho(
                      fontSize: 35.0,
                      color: Color.fromARGB(201, 0, 0, 0),
                    ),
                  ),
                ),
              ],
            ),
            ListView.separated(
              itemCount: displayed.senses.length,
              itemBuilder:
                  (context, index) => Text(displayed.senses[index].glosses),
              separatorBuilder: (context, index) => Divider(),
              shrinkWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
