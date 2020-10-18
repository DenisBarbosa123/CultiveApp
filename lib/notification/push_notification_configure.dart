import 'package:cultiveapp/model/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationConfigure {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidNotificationDetails androidPlatformChannelSpecifics;
  NotificationDetails platformChannelSpecifics;

  Future<void> configure() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'cultiveapp', 'cultiveapp_name', 'cultiveapp_description',
        importance: Importance.max, priority: Priority.high, showWhen: false);
    platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _processMessage(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _processMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    print('Token:' + await _firebaseMessaging.getToken());
  }

  static Future myBackgroundMessageHandler(Map<String, dynamic> message) {}

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {}

  Future onSelectNotification(String payload) {
    print('$payload');
  }

  void _processMessage(message) {
    _flutterLocalNotificationShow(message);
  }

  Future<void> _flutterLocalNotificationShow(message) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
    );
  }

  void subscribeTopics(List<Topicos> topicList) {
    if (topicList == null) {
      return;
    }
    topicList.forEach((topic) {
      _firebaseMessaging.subscribeToTopic(topic.nome);
    });
    print("Topics were subscribed successfully");
  }

  void unSubscribeTopics(List<Topicos> topicList) {
    if (topicList == null) {
      return;
    }
    topicList.forEach((topic) {
      _firebaseMessaging.unsubscribeFromTopic(topic.nome);
    });
    print("Topics were unSubscribed successfully");
  }
}
