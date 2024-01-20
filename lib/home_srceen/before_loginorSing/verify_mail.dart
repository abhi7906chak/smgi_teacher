import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
// import 'package:smgi/pages/after_loginOrsignUp/home_src.dart';
// import 'package:smgi/utiles/snack_bar.dart';
import 'package:smgi_teacher/home_srceen/after_login/home_src.dart';
import 'package:smgi_teacher/utils/snack_bar/snack_bar.dart';
import 'package:video_player/video_player.dart';

class VerifyEmailSrc extends StatefulWidget {
  // final FirebaseAuth userverifed;

  const VerifyEmailSrc({super.key});

  @override
  State<VerifyEmailSrc> createState() => _VerifyEmailSrcState();
}

class _VerifyEmailSrcState extends State<VerifyEmailSrc> {
  late VideoPlayerController _controller;
  Timer? _timer;
  // final key = GlobalKey<ExpandableFabState>();
  // late var usercred;

  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/verify.mp4")
      ..initialize().then((value) {
        setState(() {});
      });

    _play();
    // checkData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: InkWell(
                      onTap: () async {
                        try {
                          await auth.currentUser!
                              .delete()
                              .then((value) => Get.back());
                        } catch (e) {
                          somethingwrong();
                        }
                      },
                      child: const FaIcon(FontAwesomeIcons.chevronLeft),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: VideoPlayer(_controller),
                ),
                RichText(
                  text: const TextSpan(children: [
                    TextSpan(
                      text: "Let's verify you",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Encode",
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ]),
                ),
                RichText(
                  text: const TextSpan(
                    text: "A verification mail is sent to your email",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Encode",
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                RichText(
                  text: const TextSpan(
                    text: "Go to Gmail and verify than press the Reload Button",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Encode",
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () async {
            show();
            try {
              final user = auth.currentUser!;
              user.reload();
              if (user.emailVerified) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Homesrc(),
                    ),
                    (route) => false);
              } else {
                debugPrint("go back");
              }
            } catch (e) {
              snack_bar("error", e.toString(), context, ContentType.failure);
            }
          },
          child: const FaIcon(FontAwesomeIcons.arrowRotateLeft),
        ),
      ),
    );
  }

  Future<void> _play() async {
    _controller.setLooping(true);
    _controller.play();
  }

  void go() {
    Get.offAll(
        MaterialPageRoute(
          builder: (context) => const Homesrc(),
        ),
        transition: Transition.zoom);
  }

  void show() {
    snack_bar("Wait !!", "Wait For A Second", context, ContentType.success);
  }

  void somethingwrong() {
    snack_bar("SomeThing Went Wrong !! ", "Try Again!!", context,
        ContentType.warning);
  }
}
