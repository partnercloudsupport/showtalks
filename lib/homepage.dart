import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'settings.dart';
class HomePage extends StatefulWidget{

HomePageState createState()=>new HomePageState();
}
class HomePageState extends State<HomePage>{
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Scaffold(
        appBar: new AppBar(
          elevation: 1.0,
          title: new Text("Show Talks"),
        ),
        body: new Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            new Center(
              child: new Container(
                margin: const EdgeInsets.only(top: 10.0),
              height: 40.0,
              width: 250.0,
              decoration: new BoxDecoration(
                border: new Border.all(color: Theme.of(context).dividerColor)
              ),
              child: new ListTile(
                title: new Text("Some item"),
                trailing: new Icon(Icons.expand_more,color: Colors.white,),
              ),
            ),
            ),
           new SingleChildScrollView(
             child:  new Wrap(
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 120.0,
                  width: 100.0,
                  color: Colors.white,
                ),
                new Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 120.0,
                  width: 100.0,
                  color: Colors.white,
                ),
                new Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 120.0,
                  width: 100.0,
                  color: Colors.white,
                ),
                new Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 120.0,
                  width: 100.0,
                  color: Colors.white,
                ),
                new Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 120.0,
                  width: 100.0,
                  color: Colors.white,
                ),
                new Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 120.0,
                  width: 100.0,
                  color: Colors.white,
                ),
                new Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 120.0,
                  width: 100.0,
                  color: Colors.white,
                ),
                new Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 120.0,
                  width: 100.0,
                  color: Colors.white,
                ),
                new Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 120.0,
                  width: 100.0,
                  color: Colors.white,
                ),
                new Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 120.0,
                  width: 100.0,
                  color: Colors.white,
                ),
                new Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 120.0,
                  width: 100.0,
                  color: Colors.white,
                ),
                new Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 120.0,
                  width: 100.0,
                  color: Colors.white,
                ),

              ],
            ),
           )
          ],
        ),
      );
    }
}