import 'package:flutter/material.dart';

class NewsTabs extends StatefulWidget {
  @override
  _NewsTabsState createState() => _NewsTabsState();
}

class _NewsTabsState extends State<NewsTabs> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text("Notícias sobre o Agronegócio",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20.0)),
            ),
            Divider(color: Colors.grey[400])
          ],
        ));
  }
}
