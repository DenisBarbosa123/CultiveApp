import 'package:flutter/material.dart';

class LogoCultive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 100, bottom: 20),
          child: Image.asset("assets/leaf.png", width: 200, height: 100),
        ),
        Text("Cultive App",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
      ],
    );
  }
}
