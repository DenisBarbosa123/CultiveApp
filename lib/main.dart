import 'package:cultiveapp/notification/push_notification_configure.dart';
import 'package:cultiveapp/utils/color_util.dart';
import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PushNotificationConfigure().configure();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CultiveApp',
      debugShowCheckedModeBanner: false,
      home: Splash(),
      theme: ThemeData(primaryColor: HexColor("6FCF97")),
    );
  }
}
