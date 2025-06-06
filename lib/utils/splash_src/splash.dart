// utils/splash_src/splash.dart
/*
for this app only in video fromated splash is done
vcon - is the video player Controller
play()- is for play the controller 
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smgi_teacher/home_srceen/after_login/home_src.dart';
import 'package:smgi_teacher/home_srceen/before_loginorSing/Login_Singup.dart';
import 'package:video_player/video_player.dart';

class VideoSph extends StatefulWidget {
  const VideoSph({super.key});

  @override
  State<VideoSph> createState() => _VideoSphState();
}

class _VideoSphState extends State<VideoSph> {
  late VideoPlayerController vcon;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    vcon = VideoPlayerController.asset("assets/videos/SMGI_logo_light.mp4")
      ..initialize().then((_) {
        setState(() {});
      });
    _play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: VideoPlayer(vcon));
  }

  @override
  void dispose() {
    super.dispose();
    vcon.dispose();
  }

  Future<void> _play() async {
    vcon.play();
    await Future.delayed(const Duration(seconds: 7));

    go();
  }

  void go() {
    if (auth.currentUser != null) {
      // If user is already logged in, navigate to home screen
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Homesrc(),
          ),
          (route) => false);
    } else {
      // If user is not logged in, navigate to login/signup page
      // _navigateToLoginSignup();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginSingUpPage(),
          ),
          (route) => false);
    }
  }
}
