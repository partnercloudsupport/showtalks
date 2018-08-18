import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'objects.dart';

class TopicDetailsPage extends StatefulWidget {
  TopicDetailsPage({this.topic});
  final Topic topic;
  @override
  TopicDetailsState createState() {
    return new TopicDetailsState();
  }
}

class TopicDetailsState extends State<TopicDetailsPage> {
  bool notifications = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.2,
        title: new Text(
          "Topic Details",
          style: new TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: new SingleChildScrollView(
        physics: new AlwaysScrollableScrollPhysics(parent: new BouncingScrollPhysics()),
              child: new Container(
          child: new Wrap(
            direction: Axis.horizontal,
            children: <Widget>[
              //Topic title
              new Container(
                color: Colors.white,
                height: 40.0,
                child: new ListTile(
                  title: new Text(widget.topic?.title),
                  enabled: true,
                  trailing: new Icon(
                    Icons.arrow_forward_ios,
                    size: 10.0,
                  ),
                  onTap: () {
                   Navigator.push(
                        context,
                        new PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new TitleEditScreen(
                                  topic: widget.topic,
                                  onTopicValueChanged: (str){
                                    widget.topic.title = str;
                                  },
                                ),
                            transitionsBuilder:
                                (context, primary, secondary, child) {
                              return new SlideTransition(
                                child: child,
                                position: new Tween<Offset>(
                                        begin: new Offset(1.0, 0.0),
                                        end: new Offset(0.0, 0.0))
                                    .animate(primary),
                              );
                            }));
                  },
                ),
              ),
              new Divider(height: 1.0),
              //Description
              new Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  border: new Border(
                      bottom: new BorderSide(
                          color: CupertinoColors.lightBackgroundGray)),
                ),
                height: 80.0,
                child: new ListTile(
                  title: new Text(
                    widget.topic?.description,
                    maxLines: 3,
                  ),
                  enabled: true,
                  trailing: new Icon(
                    Icons.arrow_forward_ios,
                    size: 10.0,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        new PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new DescriptionEditScreen(
                                  topic: widget.topic,
                                  onTopicValueChanged: (str){
                                    widget.topic.description = str;
                                  },
                                ),
                            transitionsBuilder:
                                (context, primary, secondary, child) {
                              return new SlideTransition(
                                child: child,
                                position: new Tween<Offset>(
                                        begin: new Offset(1.0, 0.0),
                                        end: new Offset(0.0, 0.0))
                                    .animate(primary),
                              );
                            }));
                  },
                ),
              ),
              new Container(
                height: 30.0,
                color: Colors.white,
                  child: new ListTile(
                    enabled: false,
                  title: new Text("Show: ${widget.topic.showName}"),
                ),
              ),
              new Divider(height: 1.0,),
              new Container(
                height: 30.0,
                color: Colors.white,
                  child: new ListTile(
                    enabled: false,
                  title: new Text("Season: ${widget.topic.season}"),
                ),
              ),
              new Divider(height: 1.0,),
              new Container(
                height: 30.0,
                color: Colors.white,
                  child: new ListTile(
                    enabled: false,
                  title: new Text("Episode: ${widget.topic.episode}"),
                ),
              ),
              new Divider(height: 1.0,),
              new Container(
                height: 20.0,
              ),
              new Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  border: new Border(
                      bottom: new BorderSide(
                          color: CupertinoColors.lightBackgroundGray)),
                ),
                height: 40.0,
                child: new ListTile(
                    title: new Text("Notifications"),
                    leading: new Icon(Icons.notifications),
                    trailing: new CupertinoSwitch(
                        value: notifications,
                        onChanged: (value) {
                          setState(() {
                            notifications = value;
                          });
                        })),
              ),
              new Container(
                height: 20.0,
              ),
              //Owner details
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text("Onwer"),
                  ),
                  new Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: new Border(
                          bottom: new BorderSide(
                              color: CupertinoColors.lightBackgroundGray)),
                    ),
                    height: 40.0,
                    child: new ListTile(
                      title: new Text("Owner Name"),
                      trailing: new GestureDetector(
                        child: new Icon(
                          Icons.arrow_forward_ios,
                          size: 10.0,
                        ),
                      ),
                    ),
                  ),
                  new Container(
                    height: 20.0,
                  ),
                  new Center(
                    child: new Container(
                      width: 250.0,
                      height: 35.0,
                      child: new CupertinoButton(
                        padding: const EdgeInsets.all(0.0),
                        color: Colors.blue,
                        borderRadius: new BorderRadius.circular(0.0),
                        pressedOpacity: 0.9,
                        onPressed: () => print("Added to list"),
                        child: new Center(
                          child: new Text(
                            "Add to List",
                            style: new TextStyle(
                                color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Container(
                    height: 40.0,
                  ),
                  new DeleteButton(
                    disabled: true,
                    onPressed: () => print("Deleted"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  DeleteButton(
      {this.disabled = true,
      this.disabledColor = CupertinoColors.lightBackgroundGray,
      this.enabledColor = Colors.red,
      @required this.onPressed});
  final bool disabled;
  final VoidCallback onPressed;
  final Color enabledColor;
  final Color disabledColor;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
      onTap: !disabled ? () => onPressed() : null,
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        height: 40.0,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            border: new Border(
          top: new BorderSide(color: disabled ? disabledColor : enabledColor),
          bottom:
              new BorderSide(color: disabled ? disabledColor : enabledColor),
        )),
        child: new Text(
          "Delete Topic",
          style: new TextStyle(color: disabled ? disabledColor : enabledColor),
        ),
      ),
    );
  }
}

class TitleEditScreen extends StatefulWidget {
  TitleEditScreen({this.topic, this.onTopicValueChanged});
  final Topic topic;
  final ValueChanged<String> onTopicValueChanged;
  @override
  TitleEditScreenState createState() {
    return new TitleEditScreenState();
  }
}

class TitleEditScreenState extends State<TitleEditScreen> {
  final formKey = new GlobalKey<FormState>();
  TextEditingController title;

  void saveTopicChanges() {
    if (formKey.currentState.validate()) {
      if (widget.topic != null) {
        widget.topic.reference?.updateData({
          "title": title.text,
        });
        widget.onTopicValueChanged(title.text);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    title = new TextEditingController(text: widget.topic?.title);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Edit Title"),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          new FlatButton(
            onPressed: () => saveTopicChanges(),
            splashColor: Colors.transparent,
            child: new Text(
              "Save",
              style: new TextStyle(
                color: Colors.blue,
              ),
            ),
          )
        ],
      ),
      body: new Container(
        child: new Form(
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
                )
              ],
            ),
            child: new TextFormField(
              autofocus: true,
              validator: (val) =>
                  title.text.length > 0 ? null : "Title cannot be empty",
              controller: title,
              style: new TextStyle(
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.all(0.0),
                hintText: "Title",
                hintStyle: new TextStyle(
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DescriptionEditScreen extends StatefulWidget {
  DescriptionEditScreen({this.topic, this.onTopicValueChanged});
  final Topic topic;
  final ValueChanged<String> onTopicValueChanged;
  @override
  DescriptionEditScreenState createState() {
    return new DescriptionEditScreenState();
  }
}

class DescriptionEditScreenState extends State<DescriptionEditScreen> {
  TextEditingController description;

  void saveDescriptionChanges() {
      if (widget.topic != null) {
        widget.topic.reference?.updateData({
          "description": description.text,
        });
        widget.onTopicValueChanged(description.text);
        Navigator.of(context).pop();
      }
  }

  @override
  void initState() {
    description = new TextEditingController(text: widget.topic?.description);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Edit Description"),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          new FlatButton(
            onPressed: () => saveDescriptionChanges(),
            splashColor: Colors.transparent,
            child: new Text(
              "Save",
              style: new TextStyle(
                color: Colors.blue,
              ),
            ),
          )
        ],
      ),
      body: new Container(
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
          autofocus: true,
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
    );
  }
}
