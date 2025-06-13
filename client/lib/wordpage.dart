import 'dart:js_interop';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'entry.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'package:google_fonts/google_fonts.dart';
import 'package:kana_kit/kana_kit.dart';
import 'main.dart';
import 'uielems.dart';

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
              Wrap(
                spacing: 10.0,
                children: [
                  SelectableText(
                    displayed.word,
                    style: GoogleFonts.shipporiMincho(fontSize: MediaQuery.textScalerOf(context).scale(52.0)),
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
                        fontSize: MediaQuery.textScalerOf(context).scale(35.0),
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
                      Tooltip(
                        message: tagMap[displayed.senses[index].tags[i]],
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(5.7),
                          ),
                          child: Text(
                            displayed.senses[index].tags[i],
                            style: GoogleFonts.ebGaramond(
                              fontSize: MediaQuery.textScalerOf(context).scale(16),
                              color: Colors.white,
                            ),
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
                            style: GoogleFonts.ebGaramond(fontSize: MediaQuery.textScalerOf(context).scale(21.0)),
                          );
                        },
                      ),
                      ...List<Widget>.generate(
                        displayed.senses[index].info.length,
                        (i) {
                          return Text(
                            displayed.senses[index].info[i],
                            style: GoogleFonts.shipporiMincho(
                              fontStyle: FontStyle.italic,
                            ),
                          );
                        },
                      ),
                      ...List<
                        Widget
                      >.generate(displayed.senses[index].related.length, (i) {
                        return SelectableText(
                          "see also: ${displayed.senses[index].related[i][0]}",
                          style: GoogleFonts.shipporiMincho(),
                        );
                      }),
                      ...List<Widget>.generate(
                        displayed.senses[index].antonym.length,
                        (i) {
                          return Text(
                            "antonym: ${displayed.senses[index].antonym[i][0]}",
                            style: GoogleFonts.shipporiMincho(),
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
                physics: NeverScrollableScrollPhysics(),
              ),
              ListView.builder(
                itemBuilder:
                    (context, index) => SelectableText(
                      "${index + 1}. ${displayed.forms[index]}",
                      style: GoogleFonts.shipporiMincho(),
                    ),
                itemCount: displayed.forms.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
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
  final database = FirebaseFirestore.instance;
  bool toggled = false;
  late Vocabulary displayed;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    displayed = context.findAncestorWidgetOfExactType<WordPage>()!.displayed;
    getCollection();
  }

  void getCollection() async {
    var present = false;
    if (auth.currentUser != null) {
      var doc =
          await database.collection("saved").doc(auth.currentUser!.uid).get();
      if (doc.exists) {
        List collection = doc['saved'];
        for (int i = 0; i < collection.length; i++) {
          if (collection.elementAt(i)['id'] == displayed.id) {
            present = true;
            break;
          }
        }
      }
    }
    setState(() {
      toggled = present;
      loading = false;
    });
  }

  void a() {}

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

    if (context.mounted) {

      //The linter gives a warning here but this is actually correct.
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

      web.window.navigator.vibrate(100.toJS);
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.userChanges(),
      builder: (context, snapshot) {
        if (loading) {
          return CircularProgressIndicator(); //Not showing the button while the retrieval is still loading might be semantically better for the end user.
        }
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
