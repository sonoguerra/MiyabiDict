import 'entry.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:kana_kit/kana_kit.dart';

import 'main.dart';

class WordPage extends StatelessWidget {
  final Vocabulary displayed;
  final _kanaKit = const KanaKit();

  const WordPage({super.key, required this.displayed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBar(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 0, 0),
        //Using a ListView inside of a Column makes neither of them scrollable, so this allows for the screen to be scrolled and not overflow.
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 30.0,
            children: [
              Row(
                spacing: 10.0,
                children: [
                  Text(
                    displayed.word,
                    style: GoogleFonts.shipporiMincho(fontSize: 65.0),
                  ),
                  Tooltip(
                    message: _kanaKit.toRomaji(displayed.kana[0].text),
                    child: Text(
                      displayed.word ==
                              displayed
                                  .kana[0]
                                  .text //Displays the reading separately only if the reading doesn't already coincide with the actual word.
                          ? ""
                          : "【${displayed.kana[0].text}】",
                      style: GoogleFonts.shipporiMincho(
                        fontSize: 35.0,


                        color: Color.fromARGB(201, 0, 0, 0),
                      ),
                    ),
                  ),
                  AddVocab(),
                ],
              ),
              ListView.separated(
                itemCount: displayed.senses.length,
                itemBuilder: (context, index) {
                  List<Widget> chips = [];
                  for (
                    int i = 0;
                    i < displayed.senses[index].tags.length;
                    i++
                  ) {
                    chips.add(
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(5.7),
                        ),
                        child: Text(
                          displayed.senses[index].tags[i],
                          style: GoogleFonts.newsreader(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10.0,
                        children: [Text("${index + 1}. "), ...chips],
                      ),
                      ...List<Widget>.generate(
                        displayed.senses[index].meaning.length,
                        (i) {
                          return Text(
                            "• ${displayed.senses[index].meaning[i].text}",
                            style: GoogleFonts.newsreader(fontSize: 21.0),
                          );
                        },
                      ),
                      ...List<Widget>.generate(
                        displayed.senses[index].info.length,
                        (i) {
                          return Text(
                            displayed.senses[index].info[i],
                            style: GoogleFonts.newsreader(
                              fontStyle: FontStyle.italic,
                            ),
                          );
                        },
                      ),
                      ...List<
                        Widget
                      >.generate(displayed.senses[index].related.length, (i) {
                        return Text(
                          "see also: ${displayed.senses[index].related[i][0]}", style: GoogleFonts.newsreader()
                        );
                      }),
                      ...List<Widget>.generate(
                        displayed.senses[index].antonym.length,
                        (i) {
                          return Text(
                            "antonym: ${displayed.senses[index].antonym[i][0]}", style: GoogleFonts.newsreader()
                          );
                        },
                      ),
                      ...List<
                        Widget
                      >.generate(displayed.senses[index].languageSource.length, (
                        i,
                      ) {
                        return Text(
                          'Origin: ${displayed.senses[index].languageSource[i].lang} "${displayed.senses[index].languageSource[i].text}" ${(displayed.senses[index].languageSource[i].waseieigo ? "(wasei)" : "")}',
                          style: GoogleFonts.newsreader(),
                        );
                      }),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return Column(children: [Divider(), SizedBox(height: 16.0)]);
                },
                shrinkWrap: true,
              ),
              ListView.builder(itemBuilder: (context, index) => Text("${index + 1}. ${displayed.forms[index]}"), itemCount: displayed.forms.length, shrinkWrap: true,)
            ],
          ),
        ),
      ),


    );
  }
}

class AddVocab extends StatefulWidget {
  const AddVocab({super.key});

  @override
  State<AddVocab> createState() => _AddVocabState();
}

class _AddVocabState extends State<AddVocab> {
  bool toggled = false;

  void toggle() {
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            toggled ? "Removed from collection" : "Added to collection.",
          ),
        ),
      );
      toggled = !toggled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon:
          toggled
              ? Icon(Icons.bookmark)
              : Icon(Icons.bookmark_outline_outlined),
      onPressed: toggle,
    );
  }
}

class BookmarkLabel extends StatelessWidget {
  final List<Widget> children;

  const BookmarkLabel({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BookmarkPainter(),
      child: Row(children: children),
    );
  }
}

class BookmarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTRB(0, 0, 50, 10), paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return old != this;
  }
}
