import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
// import 'package:smgi/utiles/snack_bar.dart';
import 'package:smgi_teacher/utils/snack_bar/snack_bar.dart';
import 'package:video_player/video_player.dart';

class FpassWord extends StatefulWidget {
  // final String econ;
  const FpassWord({
    super.key,
  });

  @override
  State<FpassWord> createState() => _FpassWordState();
}

class _FpassWordState extends State<FpassWord> {
  final auth = FirebaseAuth.instance;
// Timer ? _timer;
  final emailcon = TextEditingController();
  Timer? _timer;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/forget.mp4")
      ..initialize().then((value) {
        setState(() {});
      });

    _play();
    // checkData();
  }

  Future<void> _play() async {
    _controller.setLooping(true);
    _controller.play();
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
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: InkWell(
                    onTap: () async {
                      Get.back();
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
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                width: 250,
                child: TextFormField(
                  controller: emailcon,
                  decoration: InputDecoration(
                      fillColor: Colors.black12,
                      filled: true,
                      hintText: "Email Address",
                      hintStyle: const TextStyle(
                        fontFamily: "Encode",
                        color: Colors.black87,
                        // fontWeight: FontWeight.w600
                      ),
                      contentPadding: const EdgeInsets.only(top: 10, left: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      if (checkEmail()) {
                        await auth
                            .sendPasswordResetEmail(
                                email: emailcon.text.toString())
                            .then((value) {
                          snack_bar(
                              "Sent !!",
                              "Check Mail And Reset You Password",
                              context,
                              ContentType.success);
                          Get.back();
                        });
                      }
                    } catch (e) {
                      error(e);
                    }
                  },
                  child: const Text(
                    "Send Link",
                    style: TextStyle(fontFamily: "Encode", fontSize: 18),
                  ))
            ],
          ),
        ),
      ),
    ));
  }

  bool checkEmail() {
    bool verifed = EmailValidator.validate(emailcon.text.toString());
    if (!verifed) {
      snack_bar("Enter A Valid Mail", "Not A Valied Mail Try To Corecte It ",
          context, ContentType.warning);
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _timer?.cancel();
  }

  void error(Object e) {
    if (e is FirebaseAuthException) {
      snack_bar(
          "Error  !!", e.message.toString(), context, ContentType.failure);
    } else {
      snack_bar("Error  !!", e.toString(), context, ContentType.failure);
    }
  }
}
