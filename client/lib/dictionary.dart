import 'package:flutter/material.dart';

// TODO: parse dizionario
final List<String> words = ['cacio', 'pepe', 'amatriciana', 'polenta', 'wurstel']; 

class DictionaryList extends StatelessWidget{
  const DictionaryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: words.length,
      itemBuilder: (BuildContext context, int index) {  
        var item = words[index];
        return Container(
          decoration: BoxDecoration(color: Color.fromARGB(92, 143, 143, 254)),
          child: Center(
            child: Text(
              item,
              style: TextStyle(fontSize: 32),
            ),
          ),
        );
      },
    );
  }

}