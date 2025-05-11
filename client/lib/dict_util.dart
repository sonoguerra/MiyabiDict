import 'dart:convert';
import 'dart:io';

class DictUtil {
  static Future<List<Map>> readJson(String path) async {
    final json = await File(path).readAsString();
    final map = jsonDecode(json);
    return map;
  }
}