import 'package:firebase_messaging/firebase_messaging.dart';

class notifications {
  FirebaseMessaging massage = FirebaseMessaging.instance;
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
