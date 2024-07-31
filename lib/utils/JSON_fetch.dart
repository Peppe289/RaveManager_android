// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;

// for test: "https://jsonplaceholder.typicode.com/albums/1"
class JSONfetch {
  static Future<Map<String, dynamic>> json(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// utils for get version of online repository.
  static Future<String> raveVersion(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    String sFile = response.body;
    int index = sFile.indexOf("version: ");

    if (index < 0) {
      return "";
    }

    /// split in array and get first string after "version:", then get version without "+N" (this mean revision code version, uneeded).
    return sFile.substring(index).split(" ")[1].split("+").first;
  }
}
