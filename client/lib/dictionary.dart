import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwa_dict/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart';
import 'entry.dart';
import 'wordpage.dart';

class DictionaryList extends StatefulWidget {
  const DictionaryList({super.key});

  @override
  State<StatefulWidget> createState() => _DictionaryListState();
}

class _DictionaryListState extends State<DictionaryList> {
  // shared_preferences package instance variable for saving in cache
  final Future<SharedPreferencesWithCache> _prefs =
      SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
  final _db = FirebaseFirestore.instance;
  List<Vocabulary> _results = [];
  List<String> _prevQueries = [];
  late final SearchController _sc;
  bool _english = false;
  bool _isLoading = false;
  StreamSubscription<User?>? _authStateChangesSubscription;
  
  @override
  void initState() {
    super.initState();
    _sc = SearchController();
    _loadList(); // init when the widget is created

    // listener for authentication changes
    _authStateChangesSubscription = auth.authStateChanges().listen((user) {
      // check if the widget is still mounted before calling _loadList
      if (mounted) {
        // if the user logs in or logs out then reload the list to reflect the correct data source (Firebase or cache).
        _loadList();
      }
    });
  }

  // Loads saved words list from cache
  void _loadList() async {
    List<String> queries = [];
    setState(() {
      _isLoading = true;
    });

    // if user is not logged then fetch data from cache 
    // else fetch data from Firebase 
    if (auth.currentUser == null) {
      final SharedPreferencesWithCache prefs = await _prefs;
      queries = prefs.getStringList("history") ?? [];
    } else {
      final doc = _db.collection("history").doc(auth.currentUser!.uid);
      final value = await doc.get();

      // if user already has saved history in db then fetch it,
      // else create entry in db.
      if (value.exists) {
        queries =
            (value.data()?["saved_res"] as List<dynamic>?)?.cast<String>() ??
            [];
      } else {
        doc.set({"saved_res": []});
      }
    }

    setState(() {
      _prevQueries = queries;
      _isLoading = false;
    });
  }

  // saves previous queries in cache.
  void _saveResultInCache(List<String> q) async {
    final SharedPreferencesWithCache prefs = await _prefs;
    prefs.setStringList("history", q);
  }

  void _saveResultInFirebase(String q) async {
    final doc = _db.collection("history").doc(auth.currentUser!.uid);
    doc.get().then((value) {
      // if user already has saved history in db then fetch it,
      // else create entry in db.
      if (value.exists) {
        doc.update({
          "saved_res": FieldValue.arrayUnion([q]),
        });
      } else {
        doc.set({"saved_res": []});
      }
    });
  }

  void _removeResultInFirebase(String q) async {
    final doc = _db.collection("history").doc(auth.currentUser!.uid);
    doc.get().then((value) {
      doc.update({
        "saved_res": FieldValue.arrayRemove([q]),
      });
    });
  }

  Future<void> _performSearch(String q) async {
    setState(() {
      _isLoading = true;
    });
    final fetchedRes = await Database.search(q, english: _english);

    if (fetchedRes.isNotEmpty) {
      if (!_prevQueries.contains(q)) {
        setState(() {
          _prevQueries.add(q);
        });

        if (auth.currentUser == null) {
          _saveResultInCache(_prevQueries);
        } else {
          _saveResultInFirebase(q);
        }
      }
    } else {
      if (context.mounted) {
        //The linter gives a warning here but this is actually correct.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No results found...")
          )
        );
      }
    }

    setState(() {
      _results = fetchedRes;
      _isLoading = false;
    });
  }

  void _removeResult(String q) {
    setState(() {
      _prevQueries.remove(q);
    });

    // if user is not logged in then removes value from the cache
    // else remove result from Firebase
    if (auth.currentUser == null) {
      _saveResultInCache(_prevQueries);
    } else {
      _removeResultInFirebase(q);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _sc.dispose();
    // _saveResultInCache(_prevQueries);
    _authStateChangesSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: SearchAnchor(
            builder: (context, _) {
              return SearchBar(
                leading: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final currentQuery = _sc.text;
                    if (currentQuery.isNotEmpty) {
                      _performSearch(currentQuery);
                    }
                  },
                ),
                trailing: <Widget>[
                  SegmentedButton(
                    segments: const <ButtonSegment>[
                      ButtonSegment(value: false, label: Text("🇯🇵")),
                      ButtonSegment(value: true, label: Text("🇬🇧")),
                    ],
                    selected: {_english},
                    onSelectionChanged: (value) {
                      setState(() {
                        _english = value.first;
                      });
                    },
                    showSelectedIcon: false,
                  ),
                ],
                controller: _sc,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _performSearch(value);
                    _sc.text = value;
                  }
                },
                onTap: () {
                  if (_prevQueries.isNotEmpty) {
                    _sc.openView();
                  }
                },
              );
            },
            searchController: _sc,
            suggestionsBuilder: (context, _) {
              if (_prevQueries.isEmpty) {
                return const <Widget>[];
              }
              return _prevQueries.map((res) {
                return ListTile(
                  title: Text(res),
                  onTap: () {
                    _sc.closeView(res);
                    _performSearch(res);
                  },
                  trailing: IconButton(
                    onPressed: () {
                      _sc.closeView("");
                      _removeResult(res);
                      _sc.openView();
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              }).toList();
            },
          ),
        ),
        if (_isLoading) const CircularProgressIndicator(),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: _results.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  spacing: 10.0,
                  children: [
                    Text(_results[index].listViewElements()[0]),
                    Text(
                      _results[index].listViewElements()[1],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(_results[index].listViewElements()[2]),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WordPage(_results[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
