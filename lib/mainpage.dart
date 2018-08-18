import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'settings.dart';
import 'searchpage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'parallax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'objects.dart';
import 'tvshowapi.dart';
import 'infopage.dart';
import 'package:html/dom.dart' show Document;
import 'dart:async';
import 'mylistpage.dart';
class NotificationBadgeIcon extends StatelessWidget {
  NotificationBadgeIcon(
      {this.icon, this.indicatorcolor, this.text, this.showIndicator = false});
  final IconButton icon;
  final Color indicatorcolor;
  final Widget text;
  final bool showIndicator;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Stack(
      children: <Widget>[
        icon,
        showIndicator
            ? new Positioned(
                top: 3.0,
                right: 3.0,
                child: new Container(
                  padding: EdgeInsets.all(3.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(100.0),
                    color: darkTheme ? Colors.white : Colors.blue,
                  ),
                  child: new Center(
                    child: text,
                  ),
                ),
              )
            : new Container(),
      ],
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({key, this.title})
      : super(key: key);
  final String title;
  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Document mostpopular;
  Document topshows;
  List<TvShow> popularShows = new List<TvShow>();
  List<TvShow> topRatedShows = new List<TvShow>();
  List<String> popularShowList = new List<String>();
  List<String> topRatedShowList = new List<String>();
  int lastloadedPopularShow = 0;
  int lastloadedTopRatedShow = 0;
  int navbarindex = 0;
  String groupvalue;
  List sortOptions = [
    "Top Rated",
    "Most Popular",
  ];
  void ongroupChanged(String value) {
    setState(() {
      if (groupvalue != value) {
        pageController.jumpToPage(0);
        groupvalue = value;
        Navigator.pop(context);
      }
    });
  }
  void onTap(int index) {
    setState(() {
      switch(index){
        case 0:
          navbarindex = index;
          break;
        case 1:
          Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (cons) => new MyListPage(),
              ));
          break;
        case 2:
          Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (cons) => new SearchView(),
              ));
          break;
        case 3:
          navbarindex = index;
          break;
      }
    });
  }

  PageController pageController = new PageController(viewportFraction: 0.65);
  void onPageChanged(int index) {
    switch (groupvalue) {
      case "Top Rated":
        if (index + 10 > lastloadedTopRatedShow)
         loadTopRatedwithImdbId(5);
        break;
      case "Most Popular":
        if (index + 10 > lastloadedPopularShow) {
          loadPopularwithImdbId(5);
        }
        break;
    }
  }

  void openselector() {
    showModalBottomSheet(
        context: context,
        builder: (bc) {
          return new Container(
            height: 150.0,
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
    loadDocuments().then((nu) async{
      await loadPopular();
      await loadTop();
      loadRestPopular();
      loadRestTop();
      loadPopularwithImdbId(10);
      loadTopRatedwithImdbId(10);
    });
    // TODO: implement initState
    super.initState();
  }
  Future<Null> loadDocuments() async{
    mostpopular = await findMostPopular();
    topshows = await findTopRated();
  }
  Future loadRestPopular() async{
    var dc = mostpopular.querySelectorAll("[data-tconst]");
    for(int i = 10 ; i < dc.length ; i++){
       popularShowList.add(dc[i].attributes['data-tconst']);
     }
  } 
  Future loadRestTop() async{
    var dc = topshows.querySelectorAll("[data-tconst]");
    for(int i = 10 ; i < dc.length ; i++){
       topRatedShowList.add(dc[i].attributes['data-tconst']);
     }
  } 
  Future loadPopular() async{
     var docu = mostpopular.querySelectorAll("[data-tconst]");
     for(int i = 0 ; i < 10 ; i++){
       popularShowList.add(docu[i].attributes['data-tconst']);
     }
  }
  Future loadTop() async{
     var docu = topshows.querySelectorAll("[data-tconst]");
     for(int i = 0 ; i < 10 ; i++){
       topRatedShowList.add(docu[i].attributes['data-tconst']);
     }
  }
  void loadPopularwithImdbId(int itemsToload) {
    int n = lastloadedPopularShow;
    int range;
    if(lastloadedPopularShow + itemsToload < popularShowList.length){
      range = lastloadedPopularShow + itemsToload;
    }else{
      range = popularShowList.length;
    }
    for (int i = n; i < range; i++) {
      lastloadedPopularShow++;
       TvShow show = TvShow.createEmpty();
       popularShows.add(show);
      findByImdbId(popularShowList[i]).then((v) {
        if (v != null) {
          popularShows[popularShows.indexOf(show)] = v;
        }else{
          popularShows.remove(show);
        }
        setState(() {});
      });
    }
  }

  void loadTopRatedwithImdbId(int itemsToload) {
    int n = lastloadedTopRatedShow;
     int range;
    if(lastloadedTopRatedShow + itemsToload < topRatedShowList.length){
      range = lastloadedTopRatedShow + itemsToload;
    }else{
      range = topRatedShowList.length;
    }
    for (int i = n; i < range; i++) {
      lastloadedTopRatedShow++;
      TvShow show = TvShow.createEmpty();
      topRatedShows.add(show);
      findByImdbId(topRatedShowList[i]).then((v) {
        if (v != null) {
          topRatedShows[topRatedShows.indexOf(show)] = v;
        }else{
          topRatedShows.remove(show);
        }
        setState(() {});
      });
    }
  }

  void sortTopRated() {
    for (int i = 0; i < topRatedShows.length - 2; i++) {
      for (int j = 0; j < topRatedShows.length - 2; j++) {
        if (topRatedShows[j].rating == "N/A") {
          var tmp = topRatedShows[j];
          topRatedShows[j] = topRatedShows[j + 1];
          topRatedShows[j + 1] = tmp;
          continue;
        }
        if (topRatedShows[j + 1].rating == "N/A") {
          var tmp = topRatedShows[j + 1];
          topRatedShows[j + 1] = topRatedShows[j + 2];
          topRatedShows[j + 2] = tmp;
          continue;
        }
        if (double.parse(topRatedShows[j].rating) <
            double.parse(topRatedShows[j + 1].rating)) {
          var tmp = topRatedShows[j];
          topRatedShows[j] = topRatedShows[j + 1];
          topRatedShows[j + 1] = tmp;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TvShow> imgUrls;
    if (groupvalue == sortOptions[0]) {
      imgUrls = topRatedShows;
    } else if (groupvalue == sortOptions[1]) {
      imgUrls = popularShows;
    }
    var items = [
      new BottomNavigationBarItem(
        title: new Text("Discover"),
        icon: new Icon(
          FontAwesomeIcons.compass,
          size: 25.0,
        ),
      ),
      new BottomNavigationBarItem(
        title: new Text("My List"),
        icon: new Icon(
          Icons.list,
          size: 25.0,
        ),
      ),
      new BottomNavigationBarItem(
        title: new Text("search"),
        icon: new Icon(
          Icons.search,
          size: 25.0,
        ),
      ),
      new BottomNavigationBarItem(
        title: new Text("Profile"),
        icon: new Icon(
          Icons.people,
          size: 25.0,
        ),
      ),
    ];
    // TODO: implement build
    return new Scaffold(
      body: new Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          /*new Image.network(
              imgUrls[currIndex],
              fit: BoxFit.fill,
            ),
            new Center(
                child: new ClipRect(
              child: new BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: new Container(
                  decoration: new BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.3)),
                ),
              ),
            )),*/
          new Container(
              alignment: Alignment.topLeft,
              child: new Stack(
                children: <Widget>[
                  new Container(
                    height: 80.0,
                    child: new AppBar(
                      automaticallyImplyLeading: false,
                      title: new Text(widget.title.toUpperCase()),
                      elevation: 0.1,
                      actions: <Widget>[
                        new NotificationBadgeIcon(
                          icon: new IconButton(
                            icon: new Icon(
                              Icons.textsms,
                            ),
                            onPressed: null,
                          ),
                          indicatorcolor: Colors.blue,
                          showIndicator: true,
                          text: new Text(
                            "999+",
                            style: new TextStyle(
                              color: darkTheme ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                      width: 250.0,
                      height: 40.0,
                      decoration: new BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 0.5,
                          ),
                          borderRadius: new BorderRadius.circular(5.0)),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 100.0, left: 55.0),
                      child: new Center(
                        child: new ListTile(
                          title: new Text(groupvalue),
                          trailing: new Icon(Icons.expand_more),
                          onTap: () => openselector(),
                        ),
                      )),
                  imgUrls.length<=0?new Container(
                    child: new Center(
                      child: new CupertinoActivityIndicator(),
                    ),
                  ):new Container(
                    margin: EdgeInsets.only(top: 150.0),
                    child: new SizedBox.fromSize(
                      size: new Size.fromHeight(380.0),
                      child: new PageView.builder(
                        physics: new AlwaysScrollableScrollPhysics(parent: new BouncingScrollPhysics()),
                        pageSnapping: true,
                        itemCount: imgUrls.length,
                        controller: pageController,
                        onPageChanged: (index) => onPageChanged(index),
                        itemBuilder: (_, index) {
                          return new Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 8.0),
                            child: new ShowImageHolder(
                              controller: pageController,
                              imageurl: imgUrls[index].originalImage,
                              onTap: () => Navigator.push(context, new MaterialPageRoute(
                                builder: (bu)=>new InfoPage(show:imgUrls[index]),
                              )),
                              name: imgUrls[index].name,
                              network: imgUrls[index].network,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
      bottomNavigationBar: new CupertinoTabBar(
        onTap: (index) => onTap(index),
        currentIndex: navbarindex,
        activeColor: darkTheme ? Colors.white : Colors.blue,
        backgroundColor:
            darkTheme ? Theme.of(context).primaryColor : Colors.white,
        items: items,
      ),
    );
  }
}
class ShowImageHolder extends StatefulWidget{
 ShowImageHolder(
      {key,
      this.imageurl,
      this.ratings,
      this.onTap,
      this.controller,
      this.name,
      this.network})
      : super(key: key);
  final String imageurl;
  final String ratings;
  final String name;
  final String network;
  final VoidCallback onTap;
  final ScrollController controller;
  ShowImageHolderState createState()=> new ShowImageHolderState();
}
class ShowImageHolderState extends State<ShowImageHolder> {
 Alignment alignment;
 
 @override
   void initState() {
     // TODO: implement initState
     super.initState();
   }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Material(
        elevation: 4.0,
        borderRadius: new BorderRadius.circular(5.0),
        child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new ParallaxImage(
                extent: 100.0,
                controller: widget.controller,
                image:widget.imageurl == ""?new AssetImage("assets/images/Placeholder.png"): new CachedNetworkImageProvider(widget.imageurl),
                fit: BoxFit.cover,
                placeHolder: new AssetImage("assets/images/Placeholder.png"),
              ),
              new Container(
                color: Colors.black.withOpacity(0.6),
              ),
              new Center(
                  child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    widget.name,
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: new BoxDecoration(
                      color: Colors.grey.shade50.withOpacity(0.2),
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: new Text(
                      widget.network,
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )),
              new MaterialButton(
                    onPressed: widget.onTap,
                    child: new Container(),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
            ],
          ),
        );
  }
}
