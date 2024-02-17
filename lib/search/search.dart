import 'package:flutter/material.dart';
import 'package:wiki/search/appbar_search.dart';
import 'package:wiki/settings/local_settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<String>> futureList = Future(() => []);

  void _getSearchResult(String query) async {
    var searchURL = Uri(
        scheme: 'https',
        host: fullServerName,
        path: '${wgScriptPath}api.php',
        queryParameters: {
          'action': 'opensearch',
          'search': query,
        });
    setState(() {
      futureList = getSearch(searchURL);
    });
  }

  Future<List<String>> getSearch(Uri myURL) async {
    http.Response response = await http.get(myURL);
    if (response.statusCode == 200) {
      var data = response.body;
      final List<dynamic> responce = jsonDecode(data);
      List<String> wikiContent = responce[1].cast<String>(); // 添加 .cast<String>()
      print(wikiContent);
      return wikiContent;
    } else {
      print(response.statusCode);
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSearch(
        onSearch: _getSearchResult,
      ),
      body: Column(
        children: [Expanded(
          child: FutureBuilder<List<String>>(
            future: futureList,
            builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data?[index];
                    if (item != null) {
                      return ListTile(
                        title: Text(item),
                        onTap: (){
                          setState(() {
                            PageName = item;
                            requestURL = articleURLContent(item);
                          });
                          Navigator.popAndPushNamed(context, '/');
                          },
                      );
                    } else {
                      return Container(); // 或者返回一个占位Widget
                    }
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return Container();
            },
          ),
        ),]
      ),
    );
  }
}