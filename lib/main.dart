import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smgi_teacher/utils/splash_src/splash.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SmgiTeacher());
}

class SmgiTeacher extends StatefulWidget {
  const SmgiTeacher({super.key});

  @override
  State<SmgiTeacher> createState() => _SmgiTeacherState();
}

class _SmgiTeacherState extends State<SmgiTeacher> {
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoSph(),
    );
  }
}
