import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pwa_dict/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart';
import 'entry.dart';
import 'wordpage.dart';

class DictionaryList extends StatelessWidget {
  const DictionaryList({super.key});

  @override
  Widget build(BuildContext context) => _AsyncSearch();
}

class _AsyncSearch extends StatefulWidget {
  @override
  _AsyncSearchState createState() => _AsyncSearchState();
}

class _AsyncSearchState extends State<_AsyncSearch> {
  // shared_preferences package instance variable for saving in cache
  final Future<SharedPreferencesWithCache> _prefs =
      SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
  final _db = FirebaseFirestore.instance;
  List<Vocabulary> _results = [];
  late List<String> _prevQueries;
  late final SearchController _sc;
  late bool _english = false;

  @override
  void initState() {
    super.initState();
    _sc = SearchController();
    _loadList();
  }

  // Loads saved words list from cache
  void _loadList() async {
    final SharedPreferencesWithCache prefs = await _prefs;

    var queries = prefs.getStringList("history") ?? [];

    if (auth.currentUser != null) {
      var res = await _db.collection("history").doc(auth.currentUser?.uid).get();
      queries = (res.data()?["saved_res"] as List<dynamic>?)?.cast<String>() ?? [];
    }

    setState(() {
      _prevQueries = queries;
    });
  }

  // Saves previous queries in cache.
  void _saveResultInCache(List<String> q) async {
    final SharedPreferencesWithCache prefs = await _prefs;
    prefs.setStringList("history", q);
  }

  void _saveResultInFirebase(String q) async {
    final document = _db.collection("history").doc(auth.currentUser!.uid);
    await document.get().then((value) {
      document.update({"saved_res" : FieldValue.arrayUnion([q])});
    });
  }

  void _removeResultInFirebase(String q) async {
    final document = _db.collection("history").doc(auth.currentUser!.uid);
    await document.get().then((value) {
      document.update({"saved_res": FieldValue.arrayRemove([q])});
    });
  }

  Future<void> _performSearch(String q) async {
    final fetchedRes = await Database.search(q, english: _english);

    if (fetchedRes.isNotEmpty) {
      if (!_prevQueries.contains(q)) { //possible null exception??
        setState(() {
          _prevQueries.add(q);
        });

        if (auth.currentUser == null) {
          _saveResultInCache(_prevQueries);
        }
        else {
          _saveResultInFirebase(q);
        }
      }

      setState(() {
        _results = fetchedRes;
      });
    }
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
    _saveResultInCache(_prevQueries);
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
                    icon: Icon(Icons.delete)
                  )
                );
              }).toList();
            },
          ),
        ),
        // TODO: verify if there are alternatives
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
                      builder:
                          (context) => WordPage(
                            _results[index],
                          ),
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
