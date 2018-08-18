import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import 'tvshowapi.dart';
import 'authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class TvShow {
  TvShow({
    this.id,
    this.name,
    this.genres,
    this.rating,
    this.summary,
    this.language,
    this.mediumImage,
    this.originalImage,
    this.runtime,
    this.network,
    this.schedule = "",
    this.seasons
  });
  int id;
  String name;
  List<dynamic> genres;
  String rating;
  String summary;
  String language;
  String mediumImage;
  String originalImage;
  String runtime;
  String network;
  String schedule;
  List<Season> seasons;
  List<Topic> topics;
  bool isEmpty = false;
  static TvShow createEmpty() {
    TvShow show = new TvShow();
    show.id = 0;
    show.name = "";
    show.genres = new List<dynamic>();
    show.rating = "N/A";
    show.summary = "";
    show.language = "";
    show.mediumImage = "";
    show.originalImage = "";
    show.runtime = "";
    show.network = "N/A";
    show.seasons = new List<Season>();
    show.isEmpty = true;
    return show;
  }
  static TvShow fromJson(Map jsonObject) {
    if (jsonObject['id'] == null ||
        jsonObject['name'] == null ||
        jsonObject['summary'] == null ||
        jsonObject['image'] == null) {
      return null;
    }
    var show = new TvShow();
    show.id = jsonObject['id'];
    show.name = jsonObject['name'];
    if (jsonObject['genres'] != null) show.genres = jsonObject['genres'];
    if (jsonObject['rating']['average'] != null) {
      show.rating = jsonObject['rating']['average'].toString();
    } else {
      show.rating = "N/A";
    }
    show.summary = jsonObject['summary'];
    show.summary = show.summary.replaceAll(new RegExp("<.*?>"), "");
    if (jsonObject['language'] != null) show.language = jsonObject['language'];
    show.mediumImage = jsonObject['image']['medium'];
    show.originalImage = jsonObject['image']['original'];
    if (jsonObject['network'] != null) {
      show.network = jsonObject['network']['name'];
    } else if(jsonObject['webChannel'] != null) {
      show.network = jsonObject['webChannel']['name'];
    }else{
      show.network = "N/A";
    }
    if (jsonObject['runtime'] != null) {
      show.runtime = jsonObject['runtime'].toString();
    } else {
      show.runtime = "N/A";
    }
    if (jsonObject['schedule'] != null) {
      String result = "";
      for (int i = 0; i < jsonObject['schedule']['days'].length; i++) {
        String apend =
            jsonObject['schedule']['days'][i].toString().substring(0, 3);
        result += apend;
      }
      show.schedule = jsonObject['schedule']['time'] + "|" + result;
    }
    show.isEmpty = false;
    show.getSeasonData();
    return show;
  }
  static List<TvShow> fromJsonArray(Map jsonObject) {
    if (jsonObject['queryresult'] == null) return null;
    var list = new List<TvShow>();
    for (int i = 0; i < jsonObject['queryresult'].length; i++) {
      if (jsonObject['queryresult'][i]['show']['id'] == null ||
          jsonObject['queryresult'][i]['show']['name'] == null ||
          jsonObject['queryresult'][i]['show']['summary'] == null ||
          jsonObject['queryresult'][i]['show']['image'] == null) {
        continue;
      }
      var show = TvShow.fromJson(jsonObject['queryresult'][i]['show']);
      show.isEmpty = false;
      show.getSeasonData();
      //show.getSeasonData();
      list.add(show);
    }
    return list;
  }
   Map toJson(){
    List<Map> _seasons = new List<Map>();
    seasons?.forEach((f){
      _seasons.add(f.toJson());
    });
    Map<String,dynamic> map = {
      "id":id,
      "name":name,
      "summary":summary,
      "medium":mediumImage,
      "original":originalImage,
      "genres":genres,
      "rating":rating,
      "runtime":runtime,
      "network":network,
      "seasons":_seasons,
    };
    return map;
  }
  Future<List<Season>> getSeasonData() async {
    if (seasons == null || seasons.length <= 0) {
      var response = await get(Uri.encodeFull(
          "http://api.tvmaze.com/shows/$id?embed[]=seasons&embed[]=episodes"));
      seasons = new List<Season>();
      Map json = jsonDecode(response.body);
      for (int i = 0; i < json['_embedded']['seasons'].length; i++) {
        seasons?.add(Season.fromJson(json['_embedded'], i,network,name));
      }
    }
    return seasons;
  }
  Future<List<Topic>> getCreatedTopics() async{
   var ref = AuthenticationSystem.instance.getTopicReference(id);
     await ref?.getDocuments()?.then((snapShot){
       snapShot?.documents?.forEach((doc){
         topics?.add(Topic.fromJson(doc.data,doc.reference.documentID,doc.reference));
       });
     });
   return topics;
  }
}

class Season {
  Season({this.number,this.startDate,this.endDate,this.episodes,this.futureEpisodes});
  int number;
  String startDate;
  String endDate;
  String network;
  String showName;
  List<Episode> episodes;
  List<Episode> futureEpisodes;
  Map toJson(){
    Map map = new Map();
    List<Map> _episodes = new List<Map>();
    episodes.forEach((f){
      _episodes.add(f.toJson());
    });
    map = {
      "number":number,
      "premiereDate":startDate,
      "endDate":endDate,
      "episode":_episodes,
    };
    return map;
  }
  static Season fromJson(Map jsonObject,int i,String network,String showName){
    Season season = new Season();
    season.episodes = new List<Episode>();
    season.futureEpisodes = new List<Episode>();
    season.number = jsonObject['seasons'][i]['number'];
    season.startDate = jsonObject['seasons'][i]['premiereDate'];
    season.endDate = jsonObject['seasons'][i]['endDate'];
    season.network = network;
    season.showName = showName;
    for(int i = 0 ; i < jsonObject['episodes'].length;i++){
      if(jsonObject['episodes'][i]['season'] == season.number){
      season.episodes?.add(Episode.fromJson(jsonObject['episodes'][i],network,showName));
      if(new DateTime.now().compareTo(DateTime.tryParse(jsonObject['episodes'][i]['airstamp']))< 1){
        season.futureEpisodes?.add(Episode.fromJson(jsonObject['episodes'][i],network,showName));
      }
      }
    }
    return season;
  }
}

class Episode {
  Episode({this.name,this.number,this.airTime,this.airDate,this.airStamp,this.summary,this.mediumImage,this.originalImage });
  String name;
  int number;
  int season;
  String airDate;
  String airTime;
  String airStamp;
  String summary;
  String mediumImage;
  String originalImage;
  String network;
  String showName;
  Map toJson(){
    Map<String,dynamic> map = {
      "name":name,
      "season":season,
      "number":number,
      "airdate":airDate,
      "airtime":airTime,
      "airstamp":airStamp,
      "medium":mediumImage,
      "original":originalImage,
      "summary":summary,
    };
    return map;
  }
  String get formated{
    return "S" + season.toString().padLeft(2,'0') + "E" + number.toString().padLeft(2,'0');
  }
  static Episode fromJson(Map jsonObject,String network,String showName){
    Episode episode = new Episode();
    episode.name = jsonObject['name'];
    episode.season = jsonObject['season'];
    episode.number = jsonObject['number'];
    episode.airDate = jsonObject['airdate'];
    episode.airTime = jsonObject['airtime'];
    episode.airStamp = jsonObject['airstamp'];
    if(jsonObject['image']!=null){
    episode.mediumImage = jsonObject['image']['medium'];
    episode.originalImage = jsonObject['image']['original'];
    }
    episode.summary = jsonObject['summary'];
    episode.network =network;
    episode.showName = showName;
    return episode;
  }
}

class User{
  User({this.username,this.displayName,this.country,this.imageUrl,this.watchListIds,this.friends,this.uid,this.email});
  String username;
  String displayName;
  String uid;
  String email;
  String country;
  String imageUrl;
  List<int> watchListIds;
  Map<String,String> friends;
  List<TvShow> _watchList;
  dynamic get toJson
  {
   Map<String,dynamic> userData = {
     "uid":uid,
     "username" : username,
     "email":email,
     "displayName":displayName,
     "country":country,
     "imageUrl":imageUrl,
     "WatchList":watchListIds,
     "Friends":friends,
   };
   return userData;
  }
  Future<List<TvShow>> get watchList async{
    if(_watchList == null){
    List<TvShow> showList = new List<TvShow>();
    if(_watchList == null && watchListIds.length > 0){
       watchListIds.forEach((id) async{
         TvShow show = await searchById(id);
         showList.add(show);
       });
    }
  }
  return _watchList;
  }
  static User fromJson(Map snapshotData)
  {
    User user = new User();
    user.username = snapshotData['username'];
    user.displayName = snapshotData['displayName'];
    user.country = snapshotData['country'];
    user.imageUrl = snapshotData['imageUrl'];
    user.watchListIds = snapshotData['WatchList'];
    user.friends = snapshotData['Frieds'];
    user.uid = snapshotData['uid'];
    user.email = snapshotData['email'];
    return user;
  }
}
class Topic{
DocumentReference reference;
String id;
String title;
String description;
int showId;
String showName;
String season;
String episode;
List<Map> members;
List<Message> messages;
Map get toJson{
  Map<String,dynamic> m = {
    "id":id,
    "title": title,
    "description": description,
    "showId": showId,
    "showName":showName,
    "season":season,
    "episode":episode,
    //TODO yet to implement members
    "members":members,
  };
  return m;
}
List<Map> get messagesListAsJson{
  List<Map> messages;
  this.messages?.forEach((m){
    messages?.add(m.toJson);
  });
  return messages;
}
Future<List<Message>> getMessages() async{
  await reference.collection("Messages").getDocuments().then((snapshot){
    snapshot.documents.forEach((doc){
      messages.add(Message.fromJson(doc.data));
    });
  });
  return messages;
}
static Topic fromJson(Map jsonObject,String topicId,DocumentReference ref){
  Topic topic = new Topic();
  topic.id = topicId;
  topic.reference = ref;
  topic.title = jsonObject['title'];
  topic.description = jsonObject['description'];
  topic.showId = jsonObject['showId'];
  topic.showName = jsonObject['showName'];
  topic.season = jsonObject['season'];
  topic.episode = jsonObject['episode'];
  topic.members = jsonObject['members'];
  jsonObject['messages']?.forEach((m){
    topic.messages.add(Message.fromJson(m));
  });
  return topic;
}
}
class Message{
  String displayName;
  String uid;
  String timeStamp;
  String text;
  String imageUrl;
  String videoUrl;
  String videoThumb;
  String documentId;
  // TODO implement the message class
Map get toJson{
  Map<String,dynamic> map = new Map();
  map = {
    "uid":uid,
    "timeStamp":timeStamp,
    "text":text,
    "imgUrl":imageUrl,
    "vidUrl":videoUrl,
    "videoThumb":videoThumb,
    "documentId":documentId,
    "displayName":displayName,
  };
  return map;
}
static Message fromJson(Map m){
  Message message = new Message();
  message.uid = m['uid'];
  message.timeStamp = m['timeStamp'];
  message.text = m['text'];
  message.imageUrl = m['imgUrl'];
  message.videoUrl = m['vidUrl'];
  message.documentId = m['docuemntId'];
  message.displayName = m['displayName'];
  message.videoThumb = m['videoThumb'];
  return message;
}

@override
  String toString() {
    // TODO: implement toString
    return text != null?text:
    imageUrl != null?imageUrl:
    videoUrl != null?videoUrl:
    "null";
  }
}