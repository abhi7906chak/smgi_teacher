import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Homesrc extends StatefulWidget {
  const Homesrc({super.key});

  @override
  State<Homesrc> createState() => _HomesrcState();
}

class _HomesrcState extends State<Homesrc> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final ImagePicker picker = ImagePicker();
  final RxString image = "".obs;
  var teacherdata = {};
  bool loding = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getImage(ImageSource sourse) async {
    final XFile? pickedFile = await picker.pickImage(source: sourse);
    if (pickedFile != null) {
      image.value = pickedFile.path;
    } else {
      print("user exit the program");
    }
  }

  Future<void> getData() async {
    setState(() {
      loding = true;
    });
    try {
      var teacherData = await firestore
          .collection("Teacher")
          .doc(auth.currentUser!.uid)
          .get();
      if (teacherData.exists) {
        setState(() {
          teacherdata = teacherData.data()!;
        });
      }
    } catch (e) {
      // print(e);
    }
    setState(() {
      loding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loding
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: Container(
            color: Colors.white,
            child: LiquidPullToRefresh(
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20, bottom: 20),
                  child: Row(
                    children: [
                      AnimatedTextKit(
                          repeatForever: true,
                          isRepeatingAnimation: true,
                          animatedTexts: [
                            TypewriterAnimatedText("Hello",
                                textStyle: const TextStyle(
                                    fontFamily: "Encode",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                                speed: const Duration(milliseconds: 300)),
                            TypewriterAnimatedText("hello2",
                                speed: const Duration(milliseconds: 300)),
                            TypewriterAnimatedText("hello2")
                          ]),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text(
                          teacherdata["name"] ?? "Professor",
                          style: const TextStyle(
                              fontFamily: "Encode",
                              fontWeight: FontWeight.w400,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    height: 140,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple.shade200),
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: "Any Notification....?",
                            hintStyle: TextStyle(
                                color: Colors.black54,
                                fontFamily: "Encode",
                                fontWeight: FontWeight.w400,
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const FaIcon(
                                        FontAwesomeIcons.faceSmile),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.image),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const FaIcon(
                                        FontAwesomeIcons.newspaper),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // print("pressed");
                                      },
                                      child: Container(
                                          height: 40,
                                          width: 90,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(19),
                                              gradient: const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  colors: [
                                                    Color(0xFF161697),
                                                    Color(0xFF9747FF),
                                                  ])),
                                          child: const Center(
                                              child: Text(
                                            "Post",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                                fontFamily: "Encode"),
                                          ))),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
              onRefresh: () => Future.delayed(const Duration(seconds: 3)),
            ),
          ));
  }
}
