import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' show ImageFilter;
import 'settings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'objects.dart';
import 'topicspage.dart';
class InfoPage extends StatefulWidget {
  InfoPage({key,this.show}) : super(key: key);
  final TvShow show;
  @override
  InfoPageState createState() => new InfoPageState();
}

class InfoPageState extends State<InfoPage> {
  ScrollController scrollController ;
  double toolbarOpacity = 0.0;
  @override
    void initState() {
      scrollController = new ScrollController();
      scrollController.addListener((){         
        var opacity = scrollController.offset;
        if(opacity > 10.0){
          opacity = 10.0;
        }
        toolbarOpacity = opacity/10.0;
        setState(() {});
      });
      // TODO: implement initState
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new Stack(
        fit: StackFit.passthrough,
        children: [
          //Background Image with BackdropFliter Effect
          new Image.network(
            widget.show.originalImage,
            fit: BoxFit.cover,
          ),
          new Center(
            child: new BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: new Container(
                decoration:
                    new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              ),
            ),
          ),
          new ListView(
            controller: scrollController,
            padding: const EdgeInsets.only(bottom: 70.0),
            children: <Widget>[
              new Wrap(
                children: <Widget>[
                  //Block Image
                  new Container(
                    padding: EdgeInsets.fromLTRB(0.0, 80.0, 10.0, 0.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new SizedBox(
                          height: 150.0,
                          width: 110.0,
                          child: new Material(
                              elevation: 10.0,
                              child: new Image.network(
                               widget.show.mediumImage,
                                fit: BoxFit.cover,
                              )),
                        ),
                      ],
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          new IconButton(
                            onPressed: null,
                            icon: new Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                          ),
                          new Text(
                            "Like",
                            style: new TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new IconButton(
                            onPressed: null,
                            icon: new Icon(
                              Icons.bookmark_border,
                              color: Colors.white,
                            ),
                          ),
                          new Text(
                            "Bookmark",
                            style: new TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new IconButton(
                            onPressed: null,
                            icon: new Icon(
                              CupertinoIcons.share,
                              color: Colors.white,
                            ),
                          ),
                          new Text(
                            "Share",
                            style: new TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  ),
                  new Container(
                    padding: const EdgeInsets.symmetric(horizontal:4.0,vertical: 12.0),
                    child: new ListTile(
                      dense: false,
                      title: new Text("Overview",
                       style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: new Text(
                        widget.show.summary,
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ),
                  ),
                  new Container(
                    height: 120.0,
                    padding: const EdgeInsets.all(10.0),
                    child: new Wrap(
                     alignment: WrapAlignment.spaceEvenly,
                    children: <Widget>[
                      
                     new Row(
                       children: <Widget>[
                         new Icon(FontAwesomeIcons.clockO,size: 20.0,color: Colors.white,),
                         new Text(widget.show.schedule,
                         style: new TextStyle(
                           color: Colors.white
                         ),
                         )
                       ],
                     ),
                     new Row(
                       children: <Widget>[
                         new Icon(Icons.timer,color: Colors.white,),
                         new Text(widget.show.runtime!=null?widget.show.runtime.toString() + "min":"N/A",
                         style: new TextStyle(
                           color: Colors.white
                         ),
                         )
                       ],
                     ),
                     new Row(
                       children: <Widget>[
                         new Icon(Icons.live_tv,color: Colors.white),
                         new Text(widget.show.network!=null?widget.show.network:"N/A",
                         style: new TextStyle(
                           color: Colors.white
                         ),
                         )
                       ],
                     ),
                    ],
                  ),
                  ),
                ],
              ),
            ],
          ),
          //App Bar
          new Container(
            height: 70.0,
            child: new AppBar(
              automaticallyImplyLeading: true,
              leading: new BackButton(
                color:darkTheme?Colors.white:(toolbarOpacity > 0?Colors.black:Colors.white),
              ),
              backgroundColor:darkTheme?Colors.black.withOpacity(toolbarOpacity):Colors.white.withOpacity(toolbarOpacity),
              elevation: 0.0,
              actions: <Widget>[
                toolbarOpacity==0?new Container(
                  padding: const EdgeInsets.all(15.0),
                  child:new Text(widget.show.rating != null?widget.show.rating.toString():"N/A",
                style: new TextStyle(
                  color: darkTheme?Colors.white:(toolbarOpacity > 0?Colors.black:Colors.white),
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0
                ), 
                ),
                ):new Container(),
              ],
              title: new Text(
                widget.show.name,
                style: new TextStyle(
                  color: darkTheme?Colors.white:(toolbarOpacity > 0?Colors.black:Colors.white),
                ),
              ),
            ),
          ),
          new Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: new SizedBox.fromSize(
              size: Size.fromHeight(60.0),
              child: new Container(
                child: new RaisedButton(
                  onPressed: () => Navigator.push(context, new MaterialPageRoute(
                    builder: (b)=> new TopicsPage(show: widget.show),
                  )
                  ),
                  color: Colors.black,
                  child: new Text(
                    "Join Discussion",
                    style: new TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
