import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:smgi_teacher/utils/Home_core/emoji.dart';

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
      if (kDebugMode) {
        print("okay");
      }
    } else if (setting.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("for i phone");
      }
    } else {
      if (kDebugMode) {
        print("not granted");
      }
    }
  }

  Future<void> initLocalnotifiacton(
      BuildContext context, RemoteMessage message) async {
    var androidSetting =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

    ///same for ios
    var initSetting = InitializationSettings(
      android: androidSetting,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initSetting,
      onDidReceiveNotificationResponse: (payload) {
        handleMsg(context, message);
      },
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

  void handleMsg(BuildContext context, RemoteMessage message) {
    /// Add all the key you want be sure same as database;
    if (message.data["id"] == "id1") {
      Get.to(() => Messges(
            id: message.data["id"].toString(),
          ));
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => Messges(id: message.data["id1"].toString()),
      //     ));
    } else {
      if (kDebugMode) {
        print("key not match");
      }
    }
  }

  void friebaseinit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification != null) {
        if (kDebugMode) {
          print(event.notification!.title.toString());
          print(event.notification!.body.toString());
          print(event.data["id1"]);
          print(event.data["id2"]);
        }
        // shownoti(event);
        initLocalnotifiacton(context, event);
      }
    });
  }

  // Future<void> shownoti(RemoteMessage message) async {}

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
