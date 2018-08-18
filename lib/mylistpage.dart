import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'settings.dart';
import 'objects.dart';
import 'stickylist_header.dart';
import 'stickylistrow.dart';
import 'authentication.dart';
import 'timezone.dart';
class MyListPage extends StatefulWidget {
  MyListPage({key}):super(key:key);
  @override
  MyListPageState createState() => new MyListPageState();
}

class MyListPageState extends State<MyListPage> with TickerProviderStateMixin {
  TabController tabController;
  List<Episode> upComings;
  List<TvShow> watchlist;
  @override
  void initState() {
    upComings = new List<Episode>();
   // watchlist = AuthenticationSystem.instance.currentUser?.watchList;
    tabController = new TabController(vsync: this, length: 2);
    if(watchlist != null){
    watchlist.forEach((f){
      f.seasons.forEach((f1){
        upComings.addAll(f1.futureEpisodes);
      });
    });
    sortUpComings();
    }
    // TODO: implement initState
    super.initState();
  }
  void sortUpComings()
  {
    for(int i = 0 ; i < upComings.length - 2 ; i++){
      for(int j = 0 ; j < upComings.length - 2 ; j++){
        if(DateTime.parse(upComings[j].airStamp).compareTo(DateTime.parse(upComings[j+1].airStamp)) > 0){
          var temp = upComings[j];
          upComings[j] = upComings[j+1];
          upComings[j+1] = temp;
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text("My List"),
        centerTitle: true,
        bottom: new TabBar(
          indicatorColor: darkTheme ? Colors.white : Colors.blue,
          controller: tabController,
          tabs: <Widget>[
            new Tab(
              text: "Upcoming",
            ),
            new Tab(
              text: "Watchlist",
            ),
          ],
        ),
      ),
      body: new TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: <Widget>[
          new UpcomingPage(upComings: upComings,),
          new WatchListPage(),
        ],
      ),
    );
  }
}

class UpcomingPage extends StatefulWidget {
  UpcomingPage({this.upComings});
  final List<Episode> upComings;
  @override
  UpcomingPageState createState() => new UpcomingPageState();
}

class UpcomingPageState extends State<UpcomingPage> {
  ScrollController scrollController;
  List<StickyListRow> rows;
  DateTime last ;
  @override
  void initState() {
    rows = new List<StickyListRow>();
    for(int i = 0 ; i < widget.upComings?.length;i++) {
      String airStamp = TimeZone.parseToString(
          DateTime.tryParse(widget.upComings[i].airStamp));
      if (last == null) {
        StickyListRow row = upcomingItemHeader(
            title: airStamp,
            color: airStamp == "Today" ? Colors.blue.shade600 : null);
        rows.add(row);
      } else if (last != DateTime.tryParse(widget.upComings[i].airStamp)) {
        StickyListRow row = upcomingItemHeader(
            title: airStamp,
            color: airStamp == "Today" ? Colors.blue.shade600 : null);
        rows.add(row);
      }
      else {
        StickyListRow row = upcomingItem(
            episode: widget.upComings[i], color: i < 4 ? Colors.blue.shade100 : null);
        rows.add(row);
      }
    }
    scrollController = new ScrollController();
    // TODO: implement initState
    super.initState();
  }

  HeaderRow upcomingItemHeader({String title, Color color}) {
    return new HeaderRow(
      height: 30.0,
      child: new Container(
        color: color != null
            ? color
            : darkTheme ? Colors.white : Colors.grey.shade200,
        height: 30.0,
        child: new Center(
          child: new Text(
            title,
            style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  RegularRow upcomingItem({Episode episode, Color color}) {
    return new RegularRow(
      height: 80.0,
      child: new Container(
        height: 80.0,
        decoration: new BoxDecoration(
          color: color != null
              ? color
              : darkTheme ? Colors.black54 : Colors.white70,
          border: new Border(
              bottom: new BorderSide(
            color: Colors.grey.shade100,
            width: 0.5,
          )),
        ),
        child: new ListTile(
          leading: new Material(
            type: MaterialType.transparency,
            elevation: 0.0,
            child: new Container(
              height: 65.0,
              child: new Image.asset("assets/images/Placeholder.png",
                  fit: BoxFit.cover),
            ),
          ),
          title: new Text(
            episode.showName,
            style: new TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(episode.formated),
              new Divider(
                color: Colors.transparent,
                height: 08.0,
              ),
              new Text(
                episode.showName,
                style: new TextStyle(
                  fontSize: 10.0,
                ),
              )
            ],
          ),
          trailing: new Column(
            children: <Widget>[
              new Text(episode.network),
              new Divider(
                color: Colors.transparent,
                height: 08.0,
              ),
              new Text(
                TimeZone.parseAsTimeString(episode.airStamp),
                style: new TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   if(widget.upComings != null && widget.upComings?.length > 0){
     return  new StickyList(
       children: rows,
     );
   }else{
     return  new Container(
       width: double.infinity,
       height: double.infinity,
       child: new Center(
         child: new Text("No Upcomings"),
       ),
     );
   }

  }
}

class WatchListPage extends StatefulWidget {
  WatchListPage({this.watchList});
  final List<TvShow> watchList;
  @override
  WatchListPageState createState() => new WatchListPageState();
}

class WatchListPageState extends State<WatchListPage> {
  List<Widget> tvShows;
  @override
  void initState() {
    if(widget.watchList != null){
      widget.watchList.forEach((t){
        tvShows?.add(new WatchListItem(tvShow: t,));
      });
    }
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(widget.watchList != null && widget.watchList.length > 0){
    return new ListView(
      padding: const EdgeInsets.only(bottom: 5.0),
      physics: const AlwaysScrollableScrollPhysics(
          parent: const BouncingScrollPhysics()),
      children: tvShows,
    );
  }else{
      return new Container(
        width: double.infinity,
        height: double.infinity,
        child: new Center(
          child: new Text("Watchlist is Empty"),
        ),
      );
    }
  }
}

class WatchListItem extends StatelessWidget {
  WatchListItem({key,this.tvShow}) : super(key: key);
  final TvShow tvShow;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new SizedBox.fromSize(
      size: new Size.fromHeight(60.0),
      child: new Container(
        decoration: new BoxDecoration(
          color: Colors.white70,
          border: new Border(
            bottom: new BorderSide(
              color: Colors.grey.shade100,
            ),
          ),
        ),
        child: new ListTile(
          leading: new Material(
            type: MaterialType.transparency,
            child: new  Container(
              height: 55.0,
              child: new Image.asset(tvShow.mediumImage,fit: BoxFit.cover,),
            ),
          ),
          title: new Text(tvShow.name),
          trailing:new Icon(Icons.arrow_forward_ios,size: 10.0,),
        ),
      ),
    );
  }
}
