import 'dart:convert';
import 'dart:js_interop';
import 'entry.dart';
import 'package:http/http.dart' as http;

import 'package:web/web.dart';

import 'package:kana_kit/kana_kit.dart';

class Database {

  static const _kanaKit = KanaKit();
  static const _domain = "miyabiserver.onrender.com";

  static Future<List<Vocabulary>> search(String q, {bool english = false}) async {

    List<Vocabulary> result = [];
    Uri resource;
    
    if (english) {
      resource = Uri.https(_domain, "/search/english/$q");
    }
    else {
      if (_kanaKit.isRomaji(q)) {
        q = _kanaKit.toKana(q);
      }
      resource = _kanaKit.isKana(q) ? Uri.https(_domain, "/search/reading/$q") : Uri.https(_domain, "/search/kanji/$q");
    }

    var response = await http.get(resource);
    var partial = jsonDecode(response.body)['words'];

    for (int i = 0; i < partial.length; i++) {
      result.add(Vocabulary.fromJson(partial[i]));
    }

    return result;
  }

  //TODO: Managing errors
  static Future download() async {
    






    IDBDatabase? database;
    Uri resource = Uri.https(_domain, "/dictionary/common");

    var response = await http.get(resource);
    List dictionary = jsonDecode(response.body)['words'];
    var request = window.indexedDB.open("vocabulary", 1);
    
    request.onerror = ((Event event) {
      print("No permission to create an IndexedDB.");
    }).toJS;

    request.onupgradeneeded = ((Event event) {
      database = request.result as IDBDatabase;
      var store = database?.createObjectStore("words", IDBObjectStoreParameters(keyPath: "id".toJS));

      var obj = database?.transaction("words".toJS, "readwrite").objectStore("words");
      
      var r = obj?.put(dictionary[0]);
      r?.onsuccess = ((Event event) {
        print(r.result);
      }).toJS;
      r?.onerror = ((Event event) {
        print(r.error?.message);
      }).toJS;
    }).toJS;
    //According to documentation errors "bubble" up.
    database?.onerror = ((Event event) {
      print("Database error.");
    }).toJS;

    /*for (int i = 0; i < dictionary.length; i++) {
      transaction.add(dictionary[i]);
    }*/
  }

}