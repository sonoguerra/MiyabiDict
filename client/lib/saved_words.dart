import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pwa_dict/main.dart';

class SavedWords extends StatefulWidget {
  const SavedWords({super.key});

  @override
  State<StatefulWidget> createState() => _SavedWordsState();
}

class _SavedWordsState extends State<SavedWords> {
  final _db = FirebaseFirestore.instance;
  late List<Map<String, dynamic>> _words;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _words = [];
  }

  void _loadSavedWords() async {
    var res = await _db.collection("saved").doc(auth.currentUser!.uid).get();

    // this prevents the state to be set after disposal
    if (mounted) {
      if (res.data()?["saved"] == null) {
        setState(() {
          _words = [];
        });
      } else {
        setState(() {
          _words = List<Map<String, dynamic>>.from(res.data()!["saved"]);
        });
      }
    }
  }

  void _removeWord(int i) async {
    setState(() {
      _words.removeAt(i);
    });

    final doc = _db.collection("saved").doc(auth.currentUser!.uid);
    await doc.update({"saved" : _words});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // if user logs out while in saved_words page, enters this if
          if (auth.currentUser == null) {
            return Center(
              child: Text("You need to be logged in to use this feature."),
            );
          } else {
            _loadSavedWords();
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
                  subtitle: Text(_words[index]["sense"]),
                  trailing: IconButton(
                    onPressed: () => _removeWord(index), 
                    icon: _isHovered
                      ? Icon(Icons.bookmark_remove)
                      : Icon(Icons.bookmark),
                    onHover: (value) => setState(() {
                      _isHovered = value;
                    }),
                  ),
                );
              },
            );
          }
        } else {
          // loads until auth gets all data after login
          if (auth.currentUser != null) {
            return CircularProgressIndicator();
          }

          return Center(
            child: Text("You need to be logged in to use this feature."),
          );
        }
      },
    );
  }
}
