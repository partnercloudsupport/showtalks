import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:showtalks/themeassist.dart';
import 'settings.dart';
import 'startpage.dart';
import 'topicdetails.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: darkTheme?kDefaultThemeDark:kDefaultThemeLight,
      debugShowCheckedModeBanner: false,
      home:new StartPage(title: "Show Talks",),
    );
  }
}