import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'entry.dart';
import 'package:http/http.dart' as http;

import 'package:web/web.dart';

import 'package:kana_kit/kana_kit.dart';

@JS("JSON.stringify")
external String stringify(JSAny? object); //Dart jsonEncode does not convert JS objects apparently, so a native JS method is required.

class Database {
  static const _kanaKit = KanaKit();
  static const _domain = "miyabiserver.onrender.com";

  static Future<List<Vocabulary>> search(
    String q, {
    bool english = false,
  }) async {
    List<Vocabulary> result = [];
    Uri resource;
    final Completer<List<Vocabulary>> completer = Completer();

    if (english) {
      resource = Uri.https(_domain, "/search/english/$q");
    } else {
      if (_kanaKit.isRomaji(q)) {
        q = _kanaKit.toKana(q);
      }
      resource =
          _kanaKit.isKana(q)
              ? Uri.https(_domain, "/search/reading/$q")
              : Uri.https(_domain, "/search/kanji/$q");
    }
    //TODO: preferences
    if (!window.navigator.onLine) {
      print("offline");
      IDBDatabase? database;
      var request = window.indexedDB.open("vocabulary", 1);

      request.onsuccess =
          ((Event event) {


            database = request.result as IDBDatabase;
            var databaseTransaction = database?.transaction("words".toJS);
            var req = databaseTransaction?.objectStore("words").getAll();

            req?.onsuccess =
                ((Event event) {
                  var res = (req.result as JSArray).toDart;

                  for (int i = 0; i < res.length; i++) {
                    //Another very convoluted line for type conversion between Dart and JS. See download().
                    var vocab = Vocabulary.fromJson(
                      jsonDecode(stringify(res[i])),
                    );
                    if (_kanaKit.isKana(q)) {
                      //Since we cannot infer anything about the order in which the words are stored (multiple readings) the search algorithm has to be naive and Theta(n).
                      for (int j = 0; j < vocab.kana.length; j++) {
                        if (vocab.kana[j].text.startsWith(q)) {
                          result.add(vocab);
                          break;
                        }
                      }
                    } else if (english) {
                      var found = false;
                      for (int j = 0; j < vocab.senses.length && !found; j++) {
                        for (
                          int k = 0;
                          k < vocab.senses[j].meaning.length && !found;
                          k++
                        ) {
                          var meaning =
                              vocab.senses[j].meaning[k].text.toLowerCase();
                          if (meaning.split(' ').contains(q)) {
                            result.add(vocab);
                            found = true;
                          }
                        }
                      }
                    } else {
                      for (int j = 0; j < vocab.kanjis.length; j++) {
                        if (vocab.kanjis[j].text.startsWith(q)) {
                          result.add(vocab);
                          break;
                        }
                      }
                    }
                  }

                  // Compatibility between async dart and event based js
                  completer.complete(result);
                }).toJS;
          }).toJS;

          return completer.future;
    } else {
      print("online");
      var response = await http.get(resource);
      var partial = jsonDecode(response.body)['words'];

      for (int i = 0; i < partial.length; i++) {
        result.add(Vocabulary.fromJson(partial[i]));
      }

      return result;
    }
  }

  //TODO: Managing errors
  static Future download() async {
    IDBDatabase? database;
    Uri resource = Uri.https(_domain, "/dictionary/common");

    var response = await http.get(resource);
    var dictionary = jsonDecode(response.body)['words'];
    var request = window.indexedDB.open("vocabulary", 1);

    request.onerror =
        ((Event event) {
          print("No permission to create an IndexedDB.");
        }).toJS;

    request.onupgradeneeded =
        ((Event event) {
          database = request.result as IDBDatabase;
          var store = database?.createObjectStore(
            "words",
            IDBObjectStoreParameters(keyPath: "id".toJS),
          );

          var trn = request.transaction!;
          var obj = trn.objectStore("words");

          for (int i = 0; i < dictionary.length; i++) {








            /*
          There's a problem in how the two languages interpret this object:
          Techincally speaking jsonDecode should return an instance of Map<String, dynamic>,
          but since the dictionary file returns an array (in JSON form) of words this gets cast as List.
          Since Dart interprets the implicit type as dynamic this gets converted to an obscure "_JsonMap" that does not parse correctly.
          (Not sure why Vocabulary.fromJSON() does not break since the logic is the same though).
          In short this line performs a double conversion so that Dart understands that the object is some sort of mapping between a key string and an object value,
          and consequently gets output as some sort of JS object that can be inserted into the IndexedDB.
        */
            var vocab = Map<String, dynamic>.of(dictionary[i]);
            var r = obj.put(vocab.jsify());
          }

          trn.oncomplete =
              ((Event event) {
                //TODO?
              }).toJS;
        }).toJS;

    //According to documentation errors "bubble" up.
    database?.onerror =
        ((Event event) {
          print("Database error.");
        }).toJS;
  }

  //Basic method for detecting installation of the database; doesn't check if all data is intact.
  static Future<bool> isDatabaseInstalled() async {
    var databases = await window.indexedDB.databases().toDart;
    for (int i = 0; i < databases.length; i++) {
      if (databases[i].name == "vocabulary") {
        return true;
      }
    }
    return false;  
  }
}
