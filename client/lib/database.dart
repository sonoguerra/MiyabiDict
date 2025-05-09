import 'dart:convert';
import 'entry.dart';
import 'package:http/http.dart' as http;

class Database {

  static Future<List<Vocabulary>> search(String query) async {
    List<Vocabulary> result = [];
    var response = await http.get(Uri.parse("http://localhost:5000/search/reading/$query"));
    var partial = jsonDecode(response.body);
    
    for (int i = 0; i < partial.length; i++) {
      result.add(Vocabulary.fromJson(partial['words'][i]));
    }

    return result;

  }

}