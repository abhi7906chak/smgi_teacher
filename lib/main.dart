import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smgi_teacher/home_srceen/after_login/home_src.dart';
import 'package:smgi_teacher/home_srceen/before_loginorSing/Login_Singup.dart';
import 'package:smgi_teacher/home_srceen/before_loginorSing/log_in/login_page.dart';
import 'package:smgi_teacher/home_srceen/before_loginorSing/sing_up/singup_page.dart';
import 'package:smgi_teacher/utils/splash_src/splash.dart';

import 'utils/firebase_option/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(backgroundMessge);

  runApp(const SmgiTeacher());
}

@pragma('vm:entry-point')
Future<void> backgroundMessge(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class SmgiTeacher extends StatefulWidget {
  const SmgiTeacher({super.key});

  @override
  State<SmgiTeacher> createState() => _SmgiTeacherState();
}

class _SmgiTeacherState extends State<SmgiTeacher> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const VideoSph(),
      initialRoute: "home",
      routes: {
        "splashSrc": (p0) => const VideoSph(),
        "login_singUp": (p0) => const LoginSingUpPage(),
        "singUp": (p0) => const SingUpPage(),
        "login": (p0) => const LoginPageSrc(),
        "home": (p0) => const Homesrc(),
      },
    );
  }
}
