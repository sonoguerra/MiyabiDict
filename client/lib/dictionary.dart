import 'package:flutter/material.dart';
import 'package:pwa_dict/dict_parser.dart';

final dict = DictParser();

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
  String? query;

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          onTap: () { },
          trailing: <Widget>[
            Icon(Icons.search)
          ],
        );
      },
      suggestionsBuilder: (context, controller) {
        return List<ListTile>.generate(5, (int index) {
          final String item = 'item $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              setState(() {
                controller.closeView(item);
              });
            }
          );
        });
      }
    );
  }
}