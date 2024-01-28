import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class Homesrc extends StatefulWidget {
  const Homesrc({super.key});

  @override
  State<Homesrc> createState() => _HomesrcState();
}

class _HomesrcState extends State<Homesrc> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final ImagePicker picker = ImagePicker();
  // final RxString image = "".obs;
  File? image;
  var teacherdata = {};
  List name = ["Atendence", "data"];
  bool loding = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getImage(ImageSource sourse) async {
    final XFile? pickedFile = await picker.pickImage(source: sourse);
    setState(() {
      if (pickedFile != null) {
        // image.value = pickedFile.path;
        // print(image.value);
        image = File(pickedFile.path);
      } else {
        print("user exit the program");
      }
    });
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
                  height: image == null ? 150 : 200,
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
                      // not rendereing the changes in right time

                      image == null
                          ? Container()
                          : Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  height: 70,
                                  width: 370,
                                  // color: Colors.amber,
                                  child: SingleChildScrollView(
                                    child: image == null
                                        ? const Text("data")
                                        : Image.file(
                                            image!,
                                            // height: 200,
                                            // width: 200,
                                            fit: BoxFit.fitWidth,
                                            // color: Colors.amber,
                                          ),
                                  ),
                                ),
                                IconButton(
                                  icon: const FaIcon(
                                    FontAwesomeIcons.xmark,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      image == null;
                                    });
                                    print("v");
                                    // image!.delete();
                                  },
                                ),
                              ],
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
                                  icon:
                                      const FaIcon(FontAwesomeIcons.faceSmile),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const FaIcon(FontAwesomeIcons.image),
                                  onPressed: () {
                                    getImage(ImageSource.gallery);
                                  },
                                ),
                                IconButton(
                                  icon: const FaIcon(FontAwesomeIcons.camera),
                                  onPressed: () {
                                    getImage(ImageSource.camera);
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                              ),
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
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                // color: Colors.green,
                height: 200,
                width: 100,
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                  ),
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              name[index],
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  // color: Colors.white,
                                  fontFamily: "Encode"),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(
                              "Atendece ..?",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  // color: Colors.white,
                                  fontFamily: "Encode"),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(115, 30, 234, 238),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 150,
                        width: 150,
                        color: const Color.fromARGB(195, 151, 71, 255),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
              // Image.file(image!)
              // Image.file(File.fromUri(image.value))
              // Text(image.value)
            ]),
          ));
  }
}
