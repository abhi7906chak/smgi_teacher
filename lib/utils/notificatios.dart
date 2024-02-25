// ignore_for_file: avoid_print

import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  FirebaseMessaging massage = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> getPermistion() async {
    NotificationSettings setting = await massage.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    if (setting.authorizationStatus == AuthorizationStatus.authorized) {
      print("okay");
    } else if (setting.authorizationStatus == AuthorizationStatus.provisional) {
      print("for i phone");
    } else {
      print("not granted");
    }
  }

  Future<void> initLocalnotifiacton(RemoteMessage message) async {
    var androidSetting =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

    ///same for ios
    var initSetting = InitializationSettings(
      android: androidSetting, 
    );
    await flutterLocalNotificationsPlugin.initialize(
      initSetting,
      onDidReceiveNotificationResponse: (payload) {},
    );
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      'High Importance Notifications',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(androidNotificationChannel.id.toString(),
            androidNotificationChannel.name.toString(),
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    Future.delayed(
      Duration.zero,
      () {
        flutterLocalNotificationsPlugin.show(
            0,
            message.notification!.title.toString(),
            message.notification!.body.toString(),
            notificationDetails);
      },
    );
  }

  void friebaseinit() {
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification != null) {
        print(event.notification!.title.toString());
        print(event.notification!.body.toString());
        // shownoti(event);
        initLocalnotifiacton(event);
      }
    });
  }

  Future<void> shownoti(RemoteMessage message) async {}

  Future<String> getToken() async {
    String? token = await massage.getToken();
    return token!;
  }

  void isTokenRefreash() {
    massage.onTokenRefresh.listen((event) {
      event.toString();
    });
  }
}
