import 'package:flutter/material.dart';
import 'package:wiki/base/baseui.dart';
import 'package:wiki/base/theme_data.dart';
import 'package:wiki/search/search.dart';
import 'package:wiki/pages/edit.dart';
import 'package:wiki/settings/local_settings.dart';



void main() {

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: wgSiteName,
      theme: AppTheme.theme(),
      darkTheme: AppTheme.darkTheme(),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => BaseUI(),
        '/search': (context) => const SearchPage(),
        '/edit': (context) => EditPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
      },
      themeMode: ThemeMode.system,
    );
  }
}