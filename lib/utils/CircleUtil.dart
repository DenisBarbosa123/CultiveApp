import 'package:flutter/material.dart';

class CircleUtil {

  static Widget buildCircle(String title, int status, int thisStatus){
    Color backColor ;
    Widget child;

    if(status<thisStatus){
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white));
    } else if(status==thisStatus){
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check, color: Colors.white);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
      ],
    );
  }
}