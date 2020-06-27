import 'package:cultiveapp/utils/color_util.dart';
import 'package:flutter/material.dart';
class NewsTabs extends StatefulWidget {
  @override
  _NewsTabsState createState() => _NewsTabsState();
}

class _NewsTabsState extends State<NewsTabs> {
  final Color _backColor = HexColor("6FCF97");
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      color: _backColor,
      child: Column(
        children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  "Notícias sobre o Agronegócio",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20.0)
                ),
              ),
              Divider(
                color: Colors.white
              )
        ],
      )
    );
  }
}