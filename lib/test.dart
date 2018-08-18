import 'package:flutter/material.dart';
import 'timezone.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Test extends StatelessWidget{

  @override
    Widget build(BuildContext context) {
      String test = "";
      DateTime dateTime = DateTime.parse("2013-06-25T02:00:00+00:00");
      var c = TimeZone.convert(new DateTime.now(), "EST");
      print(new DateTime.now().compareTo(c));
      print(c);
      // TODO: implement build
      return new Scaffold(
        body: new Center(
          child: new Text(test),
        ),
      );
    }
}