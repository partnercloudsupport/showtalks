import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'settings.dart';
import 'objects.dart';
import 'authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatpage.dart';
class TopicsPage extends StatefulWidget {
  TopicsPage({key, this.show}) : super(key: key);
  final TvShow show;
  @override
  TopicsPageState createState() => new TopicsPageState();
}

class TopicsPageState extends State<TopicsPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  // VoidCallback _persistantSheetCallback;
  AddTopicPage addTopicPage;
  //VoidCallback onDataAvailable;
  var sortOptions = [
    "Newest",
    "Popular",
    "Active users",
  ];
  var groupvalue;
  void ongroupChanged(String value) {
    setState(() {
      groupvalue = value;
      Navigator.pop(context);
    });
  }
  void openChat(Topic topic,{bool replace = false}){
    if(!replace){
    Navigator.push(context, new PageRouteBuilder(
      pageBuilder: (_,__,___)=> new ChatPage(topic: topic,),
      transitionsBuilder: (context,primary,secondary,child){
        return new SlideTransition(
          child: child,
          position: new Tween<Offset>(
            begin: new Offset(1.0, 0.0),
            end: new Offset(0.0, 0.0)
          ).animate(
            primary
          ),
        );
      }
    ));
    }else{
       Navigator.pushReplacement(context, new PageRouteBuilder(
      pageBuilder: (_,__,___)=> new ChatPage(topic: topic,),
      transitionsBuilder: (context,primary,secondary,child){
        return new SlideTransition(
          child: child,
          position: new Tween<Offset>(
            begin: new Offset(1.0, 0.0),
            end: new Offset(0.0, 0.0)
          ).animate(
            primary
          ),
        );
      }
    ));
    }
  }
  void addTopic() {
    if (widget.show.seasons.length > 0) {
      showDialog(
          context: context,
          builder: (c) {
            addTopicPage = new AddTopicPage(
              show: widget.show,
              onAdded: (topic)=>openChat(topic,replace: true),
            );
            return addTopicPage;
          });
    } else {
      // onDataAvailable ()=> addTopic();
    }
  }

  void showselector() {
    showModalBottomSheet(
        context: context,
        builder: (bc) {
          return new Container(
            height: 200.0,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 30.0),
                  child: new Text(
                    "Sort By",
                    style: new TextStyle(
                      color: CupertinoColors.inactiveGray,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                new Divider(
                  height: 2.0,
                ),
                new Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        new List<Widget>.generate(sortOptions.length, (co) {
                      return new SizedBox.fromSize(
                        size: Size.fromHeight(48.0),
                        child: new ListTile(
                          title: new Text(sortOptions[co]),
                          onTap: () => ongroupChanged(sortOptions[co]),
                          trailing: new Radio(
                            activeColor: Colors.blue,
                            value: sortOptions[co],
                            groupValue: groupvalue,
                            onChanged: (value) => ongroupChanged(value),
                          ),
                        ),
                      );
                    }, growable: true),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    groupvalue = sortOptions[0];
    //_persistantSheetCallback = addTopic;
    if (widget.show?.seasons == null) {
      widget.show?.getSeasonData();
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(widget.show.name),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          bottom: new PreferredSize(
            preferredSize: new Size.fromHeight(30.0),
            child: new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new FlatButton(
                    onPressed: () => showselector(),
                    child: new Text("Sort by:$groupvalue"),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: new FloatingActionButton(
          onPressed: () => addTopic(),
          backgroundColor: Colors.blue,
          child: new Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: new TopicList(
          show: widget.show,
          onSelected: (topic)=> openChat(topic),
        ));
  }
}

class AddTopicPage extends StatefulWidget {
  AddTopicPage({key, this.show, this.onAdded}) : super(key: key);
  final TvShow show;
  final ValueChanged<Topic> onAdded;
  @override
  AddTopicPageState createState() => new AddTopicPageState();
}

class AddTopicPageState extends State<AddTopicPage> {
  int selectedSeason = 0;
  int selectedEpisode = 0;
  List<CustomDropDownMenuItem> seasons;
  List<CustomDropDownMenuItem> episodes;
  final formKey = new GlobalKey<FormState>();
   TextEditingController title;
   TextEditingController description;
  void addTopic() {
    if(formKey.currentState.validate()){
      DocumentReference doc = AuthenticationSystem.instance.getTopicReference(widget.show.id).document();
      Topic topic = new Topic();
      topic.title = title.text;
      topic.description = description.text;
      topic.showName = widget.show.name;
      topic.showId = widget.show.id;
      topic.id = doc.documentID;
      topic.season = seasons[selectedSeason].text;
      topic.episode = episodes[selectedEpisode].text;
      doc.setData(topic.toJson).whenComplete((){
        widget.onAdded(topic);
      });
    }
  }

  @override
  void initState() {
    title = new TextEditingController();
    description = new TextEditingController();
    episodes = new List<CustomDropDownMenuItem>();
    seasons = new List<CustomDropDownMenuItem>();
    seasons?.add(new CustomDropDownMenuItem(
      text: "None(General)",
      value: 0,
      child: new Container(
        width: 320.0,
        padding: const EdgeInsets.all(8.0),
        child: new Text(
          "None(General)",
          style: new TextStyle(
            color: Colors.green,
          ),
        ),
      ),
    ));
    int i = 1;
    widget.show.seasons.forEach((s) {
      seasons?.add(new CustomDropDownMenuItem(
        text: "Season " + s?.number.toString(),
        value: i,
        child: new Container(
          width: 320.0,
          padding: const EdgeInsets.all(8.0),
          child: new Text(
            "Season " + s?.number.toString(),
            style: new TextStyle(
              color: Colors.green,
            ),
          ),
        ),
      ));
      i++;
    });
    refreshEpisodes();
    // TODO: implement initState
    super.initState();
  }

  void refreshEpisodes() {
    episodes.clear();
    selectedEpisode = 0;
    episodes.add(new CustomDropDownMenuItem(
      text: "None(General)",
      value: 0,
      child: new Container(
        width: 320.0,
        padding: const EdgeInsets.all(8.0),
        child: new Text(
          "None(General)",
          style: new TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
    ));
    if (selectedSeason > 0) {
      if (widget.show.seasons[selectedSeason - 1]?.episodes != null) {
        int i = 1;
        widget.show.seasons[selectedSeason - 1]?.episodes?.forEach((e) {
          episodes.add(new CustomDropDownMenuItem(
            text: "EP" + e.number.toString().padLeft(2, '0') + "." + e.name,
            value: i,
            child: new Container(
              width: 320.0,
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                "EP" + e.number.toString().padLeft(2, '0') + "." + e.name,
                style: new TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ));
          i++;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Material(
        color: Colors.transparent,
        child: new Container(
          decoration: new BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new CupertinoNavigationBar(
                border: new Border(
                    bottom: new BorderSide(
                  color: Colors.white30,
                )),
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: new Icon(Icons.close,
                      color: darkTheme ? Colors.white : Colors.blue),
                ),
                middle: new Text(
                  widget.show.name,
                  style: new TextStyle(
                    color: darkTheme ? Colors.white : Colors.black,
                  ),
                ),
                trailing: new FlatButton(
                  onPressed: () => addTopic(),
                  child: new Text(
                    "Add",
                    style: new TextStyle(
                        color: darkTheme ? Colors.white : Colors.blue),
                  ),
                ),
              ),
              new Container(
                padding: EdgeInsets.all(10.0),
                child: new Text(
                  "Title",
                  style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Form(
                key: formKey,
                child: new Container(
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0),
                    boxShadow: [
                      new BoxShadow(
                        spreadRadius: 0.5,
                        blurRadius: 0.2,
                      )                  ],
                  ),
                  child: new TextFormField(
                    validator: (val)=>title.text.length>0?null:"Title cannot be empty",
                    controller: title,
                    style: new TextStyle(
                      color: Colors.black,
                    ),
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.all(0.0),
                      hintText: "Topic",
                      hintStyle: new TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              new Container(
                padding: EdgeInsets.all(10.0),
                child: new Text(
                  "Description",
                  style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(10.0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    new BoxShadow(
                      spreadRadius: 0.5,
                      blurRadius: 0.2,
                    )
                  ],
                ),
                child: new TextField(
                  controller: description,
                  maxLines: 3,
                  style: new TextStyle(
                    color: Colors.black,
                  ),
                  decoration: new InputDecoration(
                    helperStyle: new TextStyle(color: Colors.black),
                    contentPadding: EdgeInsets.all(0.0),
                    hintText: "Description",
                    hintStyle: new TextStyle(
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              new Container(
                padding: EdgeInsets.all(10.0),
                child: new Text(
                  "Season",
                  style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Flexible(
                child: new Container(
                      margin: const EdgeInsets.all(5.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          new BoxShadow(
                            spreadRadius: 0.5,
                            blurRadius: 0.2,
                          )
                        ],
                      ),
                      child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        value: selectedSeason,
                        items: seasons,
                        onChanged: (i) {
                          setState(() {
                            if (selectedSeason != i) {
              selectedSeason = i;
              refreshEpisodes();
                            }
                          });
                        },
                      ),
                  )),
                ),
              new Container(
                padding: EdgeInsets.all(10.0),
                child: new Text(
                  "Episode",
                  style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0),
                    boxShadow: [
                      new BoxShadow(
                        spreadRadius: 0.5,
                        blurRadius: 0.2,
                      )
                    ],
                  ),
                  child: new DropdownButtonHideUnderline(
                  child: new DropdownButton(
                    value: selectedEpisode,
                    items: episodes,
                    onChanged: (i) {
                      setState(() {
                        if (selectedEpisode != i) {
                          selectedEpisode = i;
                        }
                      });
                    },
                  ),
                    )),
            ],
          ),
        ));
  }
}

class TopicView extends StatelessWidget {
  TopicView({this.topic,this.onTap});
  final Topic topic;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
      onTap: ()=>onTap(),
          child: new Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: darkTheme ? new Border() : Border.all(color: Colors.grey[300]),
        ),
        child: new ListTile(
          title: new Text(topic?.title,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 1,
              style: new TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold)),
          subtitle: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text(
                topic?.description,
                style: new TextStyle(color: Colors.black, fontSize: 20.0),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              new Divider(
                color: Colors.transparent,
              ),
              new Text(
                "season: " + topic?.season,
                style: new TextStyle(
                  color: Colors.black,
                ),
              ),
              new Text(
                "episode: " + topic?.episode,
                style: new TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          trailing: new Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class TopicList extends StatelessWidget {
  TopicList({this.show,this.onSelected});
  final TvShow show;
  final ValueChanged<Topic> onSelected;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new StreamBuilder<QuerySnapshot>(
      stream: AuthenticationSystem.instance.firestoreInstance
          .collection("/Shows/${show.id}/Topics").orderBy("title")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        
        if (!snapshot.hasData)
          return new Center(
            child: new CupertinoActivityIndicator(),
          );
        if (snapshot.data.documents.length > 0) {
          return new ListView(
            physics: new AlwaysScrollableScrollPhysics(
                parent: new BouncingScrollPhysics()),
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              Topic topic = Topic.fromJson(
                  document.data, document.documentID, document.reference);
              return new TopicView(
                topic: topic,
                onTap: ()=>onSelected(topic),
              );
            }).toList(),
          );
        } else {
          return new Container(
            width: double.infinity,
            height: double.infinity,
            child: new Center(
              child: new Text("No Topics found!"),
            ),
          );
        }
      },
    );
  }
}

class CustomDropDownMenuItem extends DropdownMenuItem {
  CustomDropDownMenuItem({key, value, child, this.text})
      : super(
          key: key,
          value: value,
          child: child,
        );
  final String text;
}
