/*
In this code Splash Screen for this app only video format is done
vcon - is the video player Controller
play()- is for play the controller 
*/

import 'package:flutter/material.dart';
import 'package:smgi_teacher/home_srceen/before_loginorSing/Login_Singup.dart';
import 'package:video_player/video_player.dart';

class VideoSph extends StatefulWidget {
  const VideoSph({super.key});

  @override
  State<VideoSph> createState() => _VideoSphState();
}

class _VideoSphState extends State<VideoSph> {
  late VideoPlayerController vcon;
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
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginSingUpPage(),
        ),
        (route) => false);
  }
}
