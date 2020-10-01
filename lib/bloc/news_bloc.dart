import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/model/news_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

const String API_KEY = "9ba3afcbe75d458496d2f9c0a4996d98";

class NewsBloc extends BlocBase {
  int page = 1;
  List<News> news = [];
  StreamController<List<News>> _streamController =
      StreamController<List<News>>();
  Sink<List<News>> get input => _streamController.sink;
  Stream<List<News>> get output => _streamController.stream;

  void getListNews() async {
    debugPrint("Calling News API");
    Response response = await Dio().get(
        "https://newsapi.org/v2/everything?q=agro&language=pt&pageSize=10&page=$page&apiKey=$API_KEY");
    if (response.statusCode == 200) {
      debugPrint("Everything ok with News API response");
      page++;
      var jsonDecoded = response.data;
      List<News> newsList = jsonDecoded["articles"].map<News>((map) {
        return News.fromJson(map);
      }).toList();
      if (news.isEmpty) {
        news.addAll(newsList);
      } else {
        news += newsList;
      }
      _streamController.sink.add(news);
    } else {
      throw Exception("Failed to load the news!");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
}
