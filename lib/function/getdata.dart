import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:wiki/settings/local_settings.dart';

Future<String> getData(prop,myURL) async {

  var exists = await credentialsFile.exists();
  var credentials;
  if (exists) {
    await rootBundle.loadString('~/.myapp/credentials.json');
  } else {
    credentials = "null";
  }
  final url = myURL;
  final type = prop;
  var headers;
  if (credentials != null) {
    headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'Mozilla/5.0 WikiApp/0.9.3 Contact/contact@frontiers.ac',
      // 使用Bearer方式添加OAuth access_token到Authorization头部
      'Authorization': 'Bearer $credentials',
    };
  } else {
    headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'Mozilla/5.0 WikiApp/0.9.3 Contact/contact@frontiers.ac',
    };
  }
  final response = await http.post(
    url,
    headers: headers,
  );

  if (response.statusCode == 200) {
    var data = response.body;
    final Map wikiTOC = jsonDecode(data);
    String wikiContent = wikiTOC['parse'][type]['*'];
    return wikiContent;
  } else {
    print(response.statusCode);
    throw Exception('Failed to load data');
  }
}