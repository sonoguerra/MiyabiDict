import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwa_dict/main.dart';

class SavedWords extends StatefulWidget {
  const SavedWords({super.key});

  @override
  State<StatefulWidget> createState() => _SavedWordsState();
}

class _SavedWordsState extends State<SavedWords> {
  final _db = FirebaseFirestore.instance;
  List _words = [];
  late Future<DocumentSnapshot<Map<String, dynamic>>> _futureWords;

  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      _initFutureWords();
    }
  }

  void _initFutureWords() {
    // Initialize saved words from logged user
     _futureWords = _db.collection("saved").doc(auth.currentUser!.uid).get();
  }

  //TODO: animations
  /* void _handleTileDeleted(int indexToRemove) {
    setState(() {
      // TODO
      //_words.removeAt(indexToRemove);
    });
  } */

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.idTokenChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (auth.currentUser == null) {
            return Center(child: Text("You need to be logged in to do that."));
          }
          else {
            return CircularProgressIndicator();
          }
        } else if (snapshot.hasData) {
          _initFutureWords();

          return FutureBuilder(
            future: _futureWords,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data?.data() != null) {
                  _words = snapshot.data!.data()!["saved"];
                }
                return ListView.builder(
                  itemCount: _words.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        spacing: 10.0,
                        children: [
                          Text(_words[index]["kanji"]),
                          Text(
                            _words[index]["reading"],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(_words[index]["sense"])
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        } else {
          return Center(child: Text("There was an error.")); //TODO
        }
      },
    );
  }
}

class _HoverIconButton extends StatefulWidget {
  const _HoverIconButton({
    super.key,
    required this.index,
    required this.onChanged,
    required this.text,
  });

  final int index;
  final ValueChanged<int> onChanged;
  final String text;

  @override
  State<StatefulWidget> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<_HoverIconButton> {
  bool _isHovered = false;

  void _handleTap() {
    widget.onChanged(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.text),
      leading: MouseRegion(
        onEnter: (event) => setState(() => _isHovered = true),
        onExit: (event) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: IconButton(
          icon: Icon(_isHovered ? Icons.bookmark_remove : Icons.bookmark),
          onPressed: () => _handleTap(),
        ),
      ),
      tileColor:
          (widget.index % 2 == 0) //TODO: change colors
              ? Theme.of(context).colorScheme.primary
              : Colors.white,
    );
  }
}
