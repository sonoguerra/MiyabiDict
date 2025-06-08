import 'package:cloud_firestore/cloud_firestore.dart';
import 'entry.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'package:kana_kit/kana_kit.dart';

class WordPage extends StatelessWidget {
  final Vocabulary displayed;
  final _kanaKit = const KanaKit();

  const WordPage(this.displayed, {super.key});

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
                  AddVocab(displayed),
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
                      Tooltip(message: tagMap[displayed.senses[index].tags[i]], child: 
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(5.7),
                          ),
                          child: Text(
                            displayed.senses[index].tags[i],
                            style: GoogleFonts.ebGaramond(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
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
                            style: GoogleFonts.ebGaramond(fontSize: 21.0),
                          );
                        },
                      ),
                      ...List<Widget>.generate(
                        displayed.senses[index].info.length,
                        (i) {
                          return Text(
                            displayed.senses[index].info[i],
                            style: GoogleFonts.ebGaramond(
                              fontStyle: FontStyle.italic,
                            ),
                          );
                        },
                      ),
                      ...List<
                        Widget
                      >.generate(displayed.senses[index].related.length, (i) {
                        return Text(
                          "see also: ${displayed.senses[index].related[i][0]}",
                          style: GoogleFonts.ebGaramond(),
                        );
                      }),
                      ...List<Widget>.generate(
                        displayed.senses[index].antonym.length,
                        (i) {
                          return Text(
                            "antonym: ${displayed.senses[index].antonym[i][0]}",
                            style: GoogleFonts.ebGaramond(),
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
                          style: GoogleFonts.ebGaramond(),
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
              ListView.builder(
                itemBuilder:
                    (context, index) =>


                        Text("${index + 1}. ${displayed.forms[index]}"),
                itemCount: displayed.forms.length,
                shrinkWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddVocab extends StatefulWidget {
  final Vocabulary displayed;

  const AddVocab(this.displayed, {super.key});

  @override
  State<AddVocab> createState() => _AddVocabState(displayed);
}

class _AddVocabState extends State<AddVocab> {
  final database = FirebaseFirestore.instance;
  bool toggled = false;
  final Vocabulary displayed;

  _AddVocabState(this.displayed);

  void denied() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("You need to be logged in to do that.")),
    );
  }

  void manage() async {
    if (auth.currentUser != null) {
      var elements = displayed.listViewElements();
      var document = database.collection("saved").doc(auth.currentUser!.uid);
      await document.get().then((item) {
        var object = {
          "id": displayed.id,
          "kanji": elements[0],
          "reading": elements[1],
          "sense": elements[2],
        };
        if (toggled) {
          document.update({
            "saved": FieldValue.arrayRemove([object]),
          });
        } else {
          if (item.exists) {
            document.update({
              "saved": FieldValue.arrayUnion([object]),
            });
          } else {
            document.set({
              "saved": [object],
            });
          }
        }
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          toggled ? "Removed from collection" : "Added to collection.",
        ),
      ),
    );
    setState(() {
      toggled = !toggled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.userChanges(),
      builder: (context, snapshot) {
        return IconButton(
          icon:
              toggled
                  ? Icon(Icons.bookmark)
                  : Icon(Icons.bookmark_outline_outlined),
          onPressed: snapshot.hasData ? manage : denied,
        );
      },
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
