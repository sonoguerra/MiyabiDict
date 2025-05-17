import 'dart:convert';
import 'entry.dart';
import 'package:http/http.dart' as http;

import 'package:kana_kit/kana_kit.dart';

class Database {

  static const _kanaKit = KanaKit();

  static Future<List<Vocabulary>> search(String q) async {

    List<Vocabulary> result = [];
    Uri resource;

    if (_kanaKit.isRomaji(q)) {
      q = _kanaKit.toKana(q);
    }
    
    resource = _kanaKit.isKana(q) ? Uri.https("miyabiserver.onrender.com", "/search/reading/$q") : Uri.https("miyabiserver.onrender.com", "/search/kanji/$q");
    
    var response = await http.get(resource);
    var partial = jsonDecode(response.body)['words'];
    for (int i = 0; i < partial.length; i++) {
      result.add(Vocabulary.fromJson(partial[i]));
    }
    return result;
  }

}