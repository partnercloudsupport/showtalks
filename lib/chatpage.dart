import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'settings.dart';
import 'objects.dart';
import 'authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'parallax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'topicdetails.dart';

class ChatPage extends StatefulWidget {
  ChatPage({this.topic});
  final Topic topic;
  @override
  ChatPageState createState() => new ChatPageState();
}

class ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  // var android = defaultTargetPlatform == TargetPlatform.android ? true : false;
  final scafflodKey = new GlobalKey<ScaffoldState>();
  TextEditingController textEditingController;
  void addMessage() {
    if (textEditingController.text.length > 0) {
      var doc = widget.topic.reference.collection("Messages").document();
      Message message = new Message();
      message.text = textEditingController.text;
      message.timeStamp = new DateTime.now().toUtc().toString();
      message.uid = AuthenticationSystem.instance.currentUser.uid;
      message.documentId = doc.documentID;
      if (AuthenticationSystem.instance.currentUser.displayName != null) {
        message.displayName =
            AuthenticationSystem.instance.currentUser.displayName;
      } else {
        message.displayName =
            AuthenticationSystem.instance.currentUser.username;
      }
      doc.setData(message.toJson);
      textEditingController.clear();
    }
  }
  void showMediaSelector(){
    showModalBottomSheet(
      context: context,
      builder: (context){
        return new MediaOptionSelector();
      }
    );
  }
  @override
  void initState() {
    textEditingController = new TextEditingController(text: "");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: scafflodKey,
      appBar: new AppBar(
        centerTitle: true,
        titleSpacing: 0.0,
        elevation: 0.3,
        title: new ListTile(
          title: new Text(widget.topic == null ? "Title" : widget.topic.title),
        ),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  new PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new TopicDetailsPage(
                            topic: widget.topic,
                          ),
                      transitionsBuilder: (context, primary, secondary, child) {
                        return new SlideTransition(
                          child: child,
                          position: new Tween<Offset>(
                                  begin: new Offset(1.0, 0.0),
                                  end: new Offset(0.0, 0.0))
                              .animate(primary),
                        );
                      }));
            },
            icon: new Icon(
              Icons.info_outline,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
              child: new Container(
            height: double.infinity,
            color: Colors.grey.shade100,
            child: widget.topic != null
                ? MessageList(widget.topic)
                : new Container(),
          )),
          new Container(
            decoration: new BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7.0),
                topRight: Radius.circular(7.0),
              ),
            ),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new IconButton(
                  padding: const EdgeInsets.all(0.0),
                  onPressed: ()=>showMediaSelector(),
                  icon: new Icon(
                    Icons.perm_media,
                    color: Colors.blue,
                  ),
                ),
                new Flexible(
                  child: new ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: 0.0,
                      minWidth: 0.0,
                      maxHeight: 120.0,
                    ),
                    child: new Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      margin: const EdgeInsets.all(5.0),
                      constraints: new BoxConstraints(
                        minHeight: 0.0,
                        minWidth: 0.0,
                        maxHeight: 120.0,
                      ),
                      decoration: new BoxDecoration(
                          color: darkTheme
                              ? Theme.of(context).primaryColorDark
                              : Colors.grey[50],
                          borderRadius: new BorderRadius.circular(10.0),
                          border: Border.all(
                              color:
                                  darkTheme ? Colors.white30 : Colors.grey[400],
                              width: 0.5)),
                      child: new SingleChildScrollView(
                        physics: new AlwaysScrollableScrollPhysics(
                          parent: new BouncingScrollPhysics(),
                        ),
                        reverse: true,
                        child: new TextField(
                          controller: textEditingController,
                          maxLines: null,
                          style: new TextStyle(
                              color: darkTheme ? Colors.white : Colors.black,
                              fontSize: 20.0),
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.all(2.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                new IconButton(
                  padding: const EdgeInsets.all(0.0),
                  onPressed: () => addMessage(),
                  icon: new Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MediaView extends StatelessWidget {
  MediaView(this.messageview);
  final MessageView messageview;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (messageview.message.imageUrl == null &&
        messageview.message.videoUrl == null) {
      return new Container(
        width: 0.0,
      );
    } else if (messageview.message.imageUrl != null) {
      if (messageview.message.imageUrl.isNotEmpty) {
        return new Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            width: 250.0,
            height: 250.0,
            //padding: const EdgeInsets.all(5.0),
            child: new Material(
              child: new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new ParallaxImage(
                    extent: 100.0,
                    image: new CachedNetworkImageProvider(
                        messageview.message.imageUrl),
                    fit: BoxFit.cover,
                    controller: messageview.scrollController,
                  ),
                ],
              ),
            ));
      } else {
        return new Container(
          width: 0.0,
        );
      }
    } else if (messageview.message.videoUrl != null) {
      if (messageview.message.videoUrl.isNotEmpty) {
        return new Container(
          width: 250.0,
          height: 250.0,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5.0),
            color: Colors.black,
          ),
          child: new Icon(
            Icons.play_circle_filled,
            color: Colors.white.withAlpha(50),
            size: 100.0,
          ),
        );
      } else {
        return new Container(
          width: 0.0,
        );
      }
    } else {
      return new Container(
        width: 0.0,
      );
    }
  }
}

class MessageView extends StatelessWidget {
  MessageView(
      {this.isMe,
      this.sameSender = false,
      this.message,
      this.animationController,
      this.scrollController});
  final bool isMe;
  final bool sameSender;
  final Message message;
  final AnimationController animationController;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    animationController?.forward();
    if (isMe) {
      return new SlideTransition(
        position: new Tween<Offset>(
          begin: new Offset(0.0, 0.2),
          end: new Offset(0.0, 0.0),
        ).animate(animationController),
        child: new Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
            color: Colors.transparent,
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: new Stack(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(10.0),
                      border: new Border.all(color: Colors.blue.shade200)),
                  constraints: new BoxConstraints(maxWidth: 250.0),
                  child: new Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      new MediaView(this),
                      new Text(
                        message.text,
                        softWrap: true,
                        maxLines: null,
                        style: new TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      );
    } else {
      return new SlideTransition(
          position: new Tween<Offset>(
            begin: new Offset(0.0, 0.2),
            end: new Offset(0.0, 0.0),
          ).animate(animationController),
          /*child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: new Row(
            children: <Widget>[
              !sameSender
                  ? new CircleAvatar(
                      radius: 20.0,
                    )
                  : new Container(
                      width: 40.0,
                    ),
              new ConstrainedBox(
                constraints: new BoxConstraints(maxWidth: 250.0),
                child: new Wrap(
                  children: <Widget>[
                    !sameSender
                        ? new Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 10.0),
                            width: double.infinity,
                            child: new Text(
                              message.displayName,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : new Container(
                            width: 0.0,
                          ),
                    new Container(
                      //margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(10.0),
                          border: new Border.all(color: Colors.black26)),
                      child: new Wrap(
                        direction: Axis.vertical,
                        children: <Widget>[
                          new MediaView(this),
                          new Text(
                            message.text,
                            style: new TextStyle(fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          ),*/
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(8.0),
                constraints: new BoxConstraints(maxWidth: 250.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(5.0),
                    border: new Border.all(color: Colors.black12)),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      message.displayName,
                      textAlign: TextAlign.start,
                      style: new TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink),
                    ),
                    new MediaView(this),
                    new Text(
                      message.text,
                      textAlign: TextAlign.start,
                      style: new TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ));
    }
  }
}

class MessageList extends StatefulWidget {
  MessageList(this.topic);
  final Topic topic;
  @override
  MessageListState createState() {
    return new MessageListState();
  }
}

class MessageListState extends State<MessageList>
    with TickerProviderStateMixin {
  ScrollController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new StreamBuilder(
      stream: widget.topic.reference.collection("Messages").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return new Container();
        } else {
          return new ListView(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            reverse: true,
            physics: new AlwaysScrollableScrollPhysics(
                parent: new BouncingScrollPhysics()),
            children: snapshot.data.documents.reversed.map((document) {
              AnimationController controller;
              if (DateTime
                      .parse(document.data['timeStamp'])
                      .difference(new DateTime.now().toUtc())
                      .inSeconds <
                  0) {
                controller = new AnimationController(
                    vsync: this, duration: new Duration(milliseconds: 0));
              } else {
                controller = new AnimationController(
                    vsync: this, duration: new Duration(milliseconds: 550));
              }
              Message message = Message.fromJson(document.data);
              if (message.uid ==
                  AuthenticationSystem.instance.currentUser.uid) {
                return new MessageView(
                  animationController: controller,
                  scrollController: this.controller,
                  message: message,
                  isMe: true,
                );
              } else {
                return new MessageView(
                  animationController: controller,
                  message: message,
                  isMe: false,
                  sameSender: false,
                );
              }
            }).toList(),
          );
        }
      },
    );
  }
}
class MediaOptionSelector extends StatelessWidget{
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Container(
        height: 80.0,
        alignment: Alignment.center,
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Text("Select Media Option",
              style: new TextStyle(
                fontWeight:  FontWeight.bold,
              ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new IconButton(
                    onPressed: ()=>print("Camera"),
                    icon: new Icon(Icons.camera_alt,size: 50.0,),
                  ),
                  new IconButton(
                    onPressed: ()=>print("Gallery"),
                    icon: new Icon(Icons.image,size: 50.0,),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
}