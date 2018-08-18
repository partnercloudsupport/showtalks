import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'tvshowapi.dart';
import 'dart:async';
import 'objects.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'settings.dart';
import 'infopage.dart';
import 'package:device_info/device_info.dart';
class SearchView extends StatefulWidget {
  @override
  SearchViewState createState() => new SearchViewState();
}

class SearchViewState extends State<SearchView> with TickerProviderStateMixin {
  Widget searchBoxSuffix;
  TextEditingController textEditingController;
  Timer timer;
  TabController tabController;
  List<TvShow> queryresult;
  bool searchnull = true;
  String lastquery;
  bool searching = false;
  List<String> recentSearches = new List<String>();
  void onSearchTextChange(String str) {
    lastquery = str;
    if (timer != null) {
      timer.cancel();
    }
    timer = null;
    timer = new Timer(new Duration(microseconds: 700), () => submitQuery(str));
    if (str.length > 0) {
      searchnull = false;
    } else {
      searchnull = true;
    }
  }

  void onSearchTextSubmitted(String str) {
    if (!recentSearches.contains(str)) {
      recentSearches.add(str);
    }
    if (str != lastquery) {
      submitQuery(str);
    }
  }

  void submitQuery(String str) {
    setState(() {
      searching = true;
      searchBoxSuffix = loading();
      if (queryresult != null) {
        queryresult.clear();
      }
    });
    searchByQuery(str).then((list) {
      setState(() {
        searching = false;
        if (str.length > 0) {
          searchBoxSuffix = cancelButton();
        } else {
          searchBoxSuffix = null;
        }
        queryresult = list;
      });
    });
  }

  void onCancelPressed() {
    setState(() {
      textEditingController.clear();
      searchBoxSuffix = null;
      searchnull = true;
    });
  }

  Widget cancelButton() {
    return new IconButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () => onCancelPressed(),
      icon: new Icon(
        Icons.cancel,
        size: 18.0,
        color: Colors.grey,
      ),
    );
  }

  Widget loading() {
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: new CupertinoActivityIndicator(
        radius: 7.0,
      ),
    );
  }

  @override
  void initState() {
    tabController = new TabController(vsync: this, length: 2);
    textEditingController = new TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    textEditingController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    searchBoxSuffix = null;
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        flexibleSpace:  new Container(
          margin: const EdgeInsets.only(top: 30.0),
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new BackButton(),
              new Flexible(
                child: new Container(
                  height: 30.0,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 10.0),
                  //padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration:new BoxDecoration(
                    color: darkTheme ? Colors.black38 : Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: darkTheme
                        ? new Border()
                        : new Border.all(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                  ),
                  child: new TextField(
                    controller: textEditingController,
                    onChanged: (str) => onSearchTextChange(str),
                    onSubmitted: (str) => onSearchTextSubmitted(str),
                    decoration: new InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(0.0),
                      prefixIcon: new IconButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: null,
                        icon: new Icon(Icons.search),
                      ),
                      suffixIcon: searchBoxSuffix,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottom: new TabBar(
          indicatorColor: darkTheme ? Colors.white : Colors.blue,
          controller: tabController,
          tabs: <Widget>[
            new Tab(text: "Shows"),
            new Tab(text: "Users"),
          ],
        ),
      ),
      body: new TabBarView(
        controller: tabController,
        physics: new NeverScrollableScrollPhysics(),
        children: <Widget>[
          searchnull
              ? new ShowSearchDefault(
                  recentSearchList: recentSearches,
                  onItemTap: (str) {
                    textEditingController.text = str;
                    searchnull = false;
                    submitQuery(str);
                  },
                )
              : new ShowSearch(
                  queryresult: queryresult,
                  searching: searching,
                ),
          new UserSearch(),
        ],
      ),
    );
  }
}

class ShowSearchDefault extends StatelessWidget {
  ShowSearchDefault({key, this.recentSearchList, this.onItemTap})
      : super(key: key);
  final List<String> recentSearchList;
  final ValueChanged<String> onItemTap;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        child: new SingleChildScrollView(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(8.0),
            child: new Text(
              "Recent Searches",
              style: new TextStyle(
                color: Theme.of(context).disabledColor,
              ),
            ),
          ),
          (recentSearchList != null && recentSearchList.length > 0)
              ? new Wrap(
                  children: new List<Widget>.generate(
                      recentSearchList != null ? recentSearchList.length : 0,
                      (index) {
                    return new GestureDetector(
                      onTap: () => onItemTap(recentSearchList[index]),
                      child: new Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                          bottom: new BorderSide(
                              color: Theme.of(context).dividerColor),
                        )),
                        child: new Center(
                          child: new Text(recentSearchList[index]),
                        ),
                      ),
                    );
                  }, growable: true),
                )
              : new Container(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: new Center(
                    child: new Text("No recent searches"),
                  ),
                ),
        ],
      ),
    ));
  }
}

class ShowSearch extends StatelessWidget {
  ShowSearch({key, this.queryresult, this.searching}) : super(key: key);
  final List<TvShow> queryresult;
  final bool searching;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new SingleChildScrollView(
      child: (queryresult != null && queryresult.length > 0)
          ? new Container(
              padding: const EdgeInsets.all(1.0),
              child: new Wrap(
                children: new List<Widget>.generate(
                    queryresult != null ? queryresult.length : 0, (index) {
                  return new Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: new BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: new Border(
                          bottom: new BorderSide(
                        style: BorderStyle.solid,
                        color: Theme.of(context).dividerColor,
                      )),
                    ),
                    child: new ListTile(
                      onTap: () => Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (bu) => new InfoPage(
                                  show: queryresult[index],
                                ),
                          )),
                      title: new Text(queryresult[index].name),
                      leading: queryresult[index].mediumImage != null
                          ? new Material(
                              elevation: 4.0,
                              borderRadius: BorderRadius.circular(0.5),
                              child: new Container(
                                child: Image.network(
                                  queryresult[index].mediumImage,
                                  fit: BoxFit.cover,
                                ),
                              ))
                          : new Container(),
                      subtitle: new Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: new BoxDecoration(
                          color: darkTheme ? Colors.black38 : Colors.grey[100],
                          borderRadius: new BorderRadius.circular(3.0),
                        ),
                        child: new Text(queryresult[index].rating.toString()),
                      ),
                      trailing: new IconButton(
                        onPressed: null,
                        icon: new Icon(
                          FontAwesomeIcons.comment,
                          color: darkTheme ? Colors.white : Colors.blue,
                        ),
                      ),
                    ),
                  );
                }, growable: true),
              ),
            )
          : new Container(
              padding: const EdgeInsets.only(top: 50.0),
              child: new Center(
                child: searching == false
                    ? new Text(
                        "No result :'(",
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Theme.of(context).platform == TargetPlatform.iOS
                        ? new CupertinoActivityIndicator()
                        : new CupertinoActivityIndicator(),
              ),
            ),
    );
  }
}

class UserSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: new Text("UserSearch"),
    );
  }
}
