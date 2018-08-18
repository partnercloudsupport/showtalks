import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'settings.dart';
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: new Text("Profile"),
        leading: new Icon(Icons.arrow_back_ios),
      ),
      body:Wrap(
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.all(9.0),
              child: new Row(
                children: <Widget>[
                  new Container(
                    child: new CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: new Text("R",
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                          )),
                      radius: 30.0,
                    ),
                  ),
                  new Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(8.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Text("RUSHABH SHROFF"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            new Divider(),
            new SingleChildScrollView(
              child: (
                 new Container(
                  child: new Wrap(
                    children: <Widget>[
                      new Container(
                        height: 35.0,
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(3.0),
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            border: darkTheme?new Border():new Border.all(color: Colors.grey[200])
                            ),
                        child:new ListTile(
                          dense: false,
                              title:  new Text(
                                  "WatchList",
                                  style: new TextStyle(color: Colors.black),
                                ),
                                trailing: new Icon(Icons.arrow_forward_ios,color: Colors.black,size: 10.0,),
                            )
                      ),
                    ],
                  ),
                )
              ),
            ),
          ],
        ),
    );
  }
}
