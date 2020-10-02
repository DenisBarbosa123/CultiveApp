import 'package:cultiveapp/model/news_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class NewsTile extends StatelessWidget {
  News news;
  NewsTile(this.news);

  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.5, 0.0, 0.5),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  news.author == null ? "Fonte Desconhecida" : "${news.author}",
                  style: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic)),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        "${news.title}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22.0),
                      ),
                      flex: 3,
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                          height: 80.0,
                          width: 80.0,
                          child: Image.network(news.urlToImage,
                              fit: BoxFit.cover)),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Text(formatter.format(news.publishedAt),
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 150),
                      child: IconButton(
                          icon: Icon(Icons.open_in_browser,
                              color: Colors.green[900]),
                          onPressed: () {
                            launch("${news.url}");
                          })),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
