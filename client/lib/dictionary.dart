import 'package:flutter/material.dart';
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
  final Future<SharedPreferencesWithCache> _prefs = 
      SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions());
  List<Vocabulary> _results = [];
  late List<String> _prevQueries;
  late final SearchController _sc;

  @override
  void initState() {
    super.initState();
    _sc = SearchController();
    _loadList();
  }

  /// Loads saved words list from cache
  /// TODO: implement with auth
  void _loadList() async {
    final SharedPreferencesWithCache prefs = await _prefs;
    _prevQueries = prefs.getStringList("saved_words") ?? [];
  }

  /// Saves previous queries in cache.
  /// TODO: prefs.setStringList("saved_words" + uid, q);
  void _saveResultInCache(List<String> q) async {
    final SharedPreferencesWithCache prefs = await _prefs;
    prefs.setStringList("saved_words", q);
  }

  //TODO
  Future<void> _performSearch(String q) async {
    final fetchedRes = await Database.search(q);

    setState(() {
      // _query = q;
      if (!_prevQueries.contains(q)) {
        _prevQueries.add(q);
        _saveResultInCache(_prevQueries);
      }
      _results = fetchedRes;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _sc.closeView("");
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
                );
              }).toList();
            },
          ),
        ),
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
                            displayed: _results[index],
                          ), // wrong implementation
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
