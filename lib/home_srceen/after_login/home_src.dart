// home_srceen/after_login/home_src.dart
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/foundation.dart";
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smgi_teacher/attendence/attendence.dart';
import 'package:smgi_teacher/home_srceen/after_login/Home/home_src_core.dart/post_botton.dart';
import 'package:smgi_teacher/utils/Home_core/teacher_profile_edit.dart';
import 'package:smgi_teacher/utils/account_validate_src.dart';
import 'package:smgi_teacher/utils/image_time_table.dart';
import 'package:smgi_teacher/utils/notificatios.dart';
import 'package:smgi_teacher/utils/social_links.dart';
import 'package:smgi_teacher/utils/students_show.dart';
import 'package:smgi_teacher/utils/subject.dart';

class Homesrc extends StatefulWidget {
  const Homesrc({super.key});

  @override
  State<Homesrc> createState() => _HomesrcState();
}

class _HomesrcState extends State<Homesrc> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final notiTitle = TextEditingController();

  final ImagePicker picker = ImagePicker();
  final String textfiledErrormsg = "";
  File? image;

  var teacherdata = {};
  List name = ["Atendence", "Request"];
  bool loding = false;
  Notifications notification = Notifications();
  @override
  void initState() {
    super.initState();
    try {
      Notifications().getPermistion();
      Notifications().isTokenRefreash();
      // Notifications().initLocalnotifiacton(context, );
      Notifications().friebaseinit(context);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    notification.getToken().then((value) {
      if (kDebugMode) {
        print("token     $value");
      }
    });
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
        if (kDebugMode) {
          print("user exit the program");
        }
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
          .doc(auth.currentUser!.email.toString())
          .get();
      if (teacherData.exists) {
        setState(() {
          teacherdata = teacherData.data()!;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    setState(() {
      loding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: loding
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Scaffold(
                  body: Container(
                color: Colors.white,
                child: ListView(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 20, bottom: 20),
                    child: Row(
                      children: [
                        AnimatedTextKit(
                            repeatForever: true,
                            isRepeatingAnimation: true,
                            animatedTexts: [
                              TypewriterAnimatedText(
                                "Hello",
                                textStyle: const TextStyle(
                                    fontFamily: "Namaste",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                                speed: const Duration(milliseconds: 300),
                              ),
                              TypewriterAnimatedText("Hey",
                                  textStyle: const TextStyle(
                                      fontFamily: "Encode",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  speed: const Duration(milliseconds: 300)),
                              TypewriterAnimatedText("Hi",
                                  textStyle: const TextStyle(
                                      fontFamily: "Encode",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  speed: const Duration(milliseconds: 300)),
                            ]),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Text(
                            // ignore: prefer_interpolation_to_compose_strings
                            "Prof.  " + teacherdata["name"],
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
                            controller: notiTitle,
                            decoration: InputDecoration(
                              errorText: textfiledErrormsg.isNotEmpty
                                  ? textfiledErrormsg
                                  : null,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "Any Notification....?",
                              hintStyle: const TextStyle(
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
                                    SizedBox(
                                      height: 70,
                                      width: 370,
                                      // color: Colors.amber,
                                      child: SingleChildScrollView(
                                        child: image == null
                                            ? const Text("data")
                                            : Image.file(
                                                image!,
                                                fit: BoxFit.fitWidth,
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
                                          image = null;
                                        });
                                        if (kDebugMode) {
                                          print("Image remove done !!");
                                        }
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
                                    // IconButton(
                                    //   icon: const FaIcon(
                                    //       FontAwesomeIcons.faceSmile),
                                    //   onPressed: () {},
                                    // ),
                                    IconButton(
                                      icon:
                                          const FaIcon(FontAwesomeIcons.image),
                                      onPressed: () {
                                        getImage(ImageSource.gallery);
                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          const FaIcon(FontAwesomeIcons.camera),
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
                                        onTap: () async {
                                          PostBotton()
                                              .postbutton(
                                                  context, notiTitle, image)
                                              .then((value) {
                                            setState(() {
                                              notiTitle.text = "";
                                              image = null;
                                              // }
                                            });
                                          });
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
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              () => const TempAtten(),
                              transition: Transition.downToUp,
                            );
                          },
                          child: Container(
                            height: 200,
                            width: 100,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    colors: [
                                      Color(0xFF161697),
                                      Color(0xFF9747FF),
                                    ]),
                                // color: Colors.,
                                borderRadius: BorderRadius.circular(15)),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  child: Text(
                                    "Today",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontFamily: "Encode"),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 10, bottom: 10),
                                  child: Text(
                                    "Atendece ..?",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontFamily: "Encode"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              () => TeacherProfileForm(),
                              transition: Transition.downToUp,
                            );
                          },
                          child: Container(
                            height: 200,
                            // width: 100,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    colors: [
                                      Color(0xFF161697),
                                      Color(0xFF9747FF),
                                    ]),
                                borderRadius: BorderRadius.circular(15)),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  child: Text(
                                    "Profile",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontFamily: "Encode"),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 10, bottom: 10),
                                  child: Text(
                                    "Edit profile...?",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontFamily: "Encode"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              String mail = auth.currentUser!.email.toString();
                              Get.to(
                                  () => TeacherSubjectManager(teacherId: mail),
                                  transition: Transition.downToUp);
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(115, 30, 234, 238),
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Center(
                                  child: Text(
                                "Subjects",
                                style: TextStyle(fontSize: 25),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => const StudentListScreen(),
                                  transition: Transition.downToUp);
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  // color: const Color.fromARGB(115, 30, 234, 238),
                                  color:
                                      const Color.fromARGB(195, 151, 71, 255),
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Center(
                                  child: Text(
                                "Sutdents",
                                style: TextStyle(fontSize: 25),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              Get.to(() => const ImagePickerWidget(),
                                  transition: Transition.downToUp);
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(115, 30, 234, 238),
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Center(
                                  child: Text(
                                "Time Table",
                                style: TextStyle(fontSize: 25),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Image.file(image!)
                  // Image.network(networkImage)
                  // Image.file(File.fromUri(image.value))
                  // Text(image.value)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => const StudentApprovalScreen(),
                            transition: Transition.downToUp);
                      },
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.purple.shade100,
                            borderRadius: BorderRadius.circular(15)),
                        child: const Center(
                            child: Text(
                          "Student Request\n For validating their profile",
                          style: TextStyle(
                              height: 2,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Encode"),
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: Colors.deepPurple.shade200, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        "New features coming soon to enhance your experience!",
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.deepPurple.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Get.to(
                          () => const SocialLinksScreen(
                            facebookUrl:
                                "https://www.facebook.com/profile.php?id=100022992082245",
                            instagramUrl:
                                "https://www.instagram.com/abhishek_khatik_214/",
                            githubUrl: "https://github.com/abhi7906chak",
                            linkedinUrl:
                                "https://www.linkedin.com/in/abhishek-kumar-chak/",
                          ),
                          transition: Transition.downToUp,
                        );
                      },
                      child: Container(
                        // margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Colors.deepPurple, width: 1.2),
                        ),
                        child: Center(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.deepPurple,
                              ),
                              children: [
                                TextSpan(text: 'Made with '),
                                WidgetSpan(
                                  child: Icon(Icons.favorite,
                                      color: Colors.red, size: 16),
                                ),
                                TextSpan(text: ' by Abhishek Chak • BCA \'25'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              )),
            ),
    );
  }
}
