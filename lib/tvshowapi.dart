import 'dart:async';
import 'package:http/http.dart' as Http;
import 'dart:convert';
import 'objects.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
//requires Urls
String searchbyquery = "https://api.tvmaze.com/search/shows";
String searchbyid = "https://api.tvmaze.com/shows";
String imdbsearchlink = "http://api.tvmaze.com/lookup/shows";

Future<List<TvShow>> searchByQuery(String query) async{
  var url = Uri.encodeFull(searchbyquery + "?q=$query");
  Http.Response response = await Http.get(url);
  try{
  String json = response.body;
  String pre = "{\"queryresult\":";
  String post = "}";
  String r = pre + json + post;
  List<TvShow> tvShows = TvShow.fromJsonArray(jsonDecode(r)); 
  return tvShows;
  }catch(e){
    return new List<TvShow>();
  }
}
Future<TvShow> searchById(int id) async{
  var url = Uri.encodeFull(searchbyid + "/$id");
  var response = await Http.get(url);
   try{
   var json = jsonDecode(response.body);
   TvShow tvShow = TvShow.fromJson(json);
   return tvShow;
   }catch(e){
     return null;
   }
}
Future<TvShow> findByImdbId(String imdbId) async{
   var url = Uri.encodeFull(imdbsearchlink + "?imdb=$imdbId");
   var response = await Http.get(url);
   try{
   var json = jsonDecode(response.body);
   TvShow tvShow = TvShow.fromJson(json);
   return tvShow;
   }catch(e){
     return null;
   }
}/*
Future<List<String>> findMostPopular() async{
  List<String> result = new List<String>();
   Http.Response response = await Http.get(Uri.encodeFull('https://www.imdb.com/chart/tvmeter'));
   Document document = parser.parse(response.body);
   document.querySelectorAll("[data-tconst]").forEach((f){
    result.add(f.attributes['data-tconst']);
 });
 return result;
}
Future<List<String>> findTopRated() async{
  List<String> result = new List<String>();;
   Http.Response response = await Http.get(Uri.encodeFull('https://www.imdb.com/chart/toptv'));
   Document document = parser.parse(response.body);
   document.querySelectorAll("[data-tconst]").forEach((f){
    result.add(f.attributes['data-tconst']);
 });
 return result;
}*/
Future<Document> findMostPopular() async{
   Http.Response response = await Http.get(Uri.encodeFull('https://www.imdb.com/chart/tvmeter'));
   Document document = parser.parse(response.body);
 return document;
}
Future<Document> findTopRated() async{
   Http.Response response = await Http.get(Uri.encodeFull('https://www.imdb.com/chart/toptv'));
   Document document = parser.parse(response.body);
 return document;
}