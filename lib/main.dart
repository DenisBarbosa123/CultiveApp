import 'package:cultiveapp/screens/login_screen.dart';
import 'package:cultiveapp/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CultiveApp',
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

