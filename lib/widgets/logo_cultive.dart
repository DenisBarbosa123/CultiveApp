import 'package:flutter/material.dart';
class LogoCultive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 40, bottom: 20),
          child: Image.asset("assets/leaf.png", width: 300, height: 200),
        ),
        Text(
            "CultiveApp",
            style: TextStyle(
                color: Colors.black,
                fontSize: 40.0,
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center),
      ],
    );
  }
}
