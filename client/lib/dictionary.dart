import 'package:flutter/material.dart';
import 'package:pwa_dict/dict_util.dart';

class DictionaryList extends StatelessWidget{
  const DictionaryList({super.key});
  
  @override
  Widget build(BuildContext context) => _AsyncSearch();
}

class _AsyncSearch extends StatefulWidget {
  @override
  _AsyncSearchState createState() => _AsyncSearchState();
}

class _AsyncSearchState extends State<_AsyncSearch> {
  String? _query;
  List<String> _results = []; 
  final List<String> _prevQueries = [];
  late final SearchController _sc;

  @override
  void initState() {
    super.initState();
    _sc = SearchController();
  }

  @override
  void dispose() {
    super.dispose();
    _sc.dispose();
  }

  //TODO
  Future<void> _performSearch(String q) async {
    // final fetchedResults = await DictUtil.readJson("assets/jmdict-eng-common-3.6.1.json");
    setState(() {
      _query = q;
      if (!_prevQueries.contains(q)) {
        _prevQueries.add(q);
      }
      _results = ['Result for "$q"']; // Replace with actual results
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      SearchAnchor(
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
      Expanded(
        child: ListView.builder(
          itemCount: _results.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_results[index]),
            );
          },
        ),
      ),
      ],
    );
  }
}
