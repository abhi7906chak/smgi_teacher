// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:smgi/models/student_model.dart';
// import 'package:smgi/pages/after_loginOrsignUp/Verify%20Email/verify_email.dart';
// import 'package:smgi/pages/after_loginOrsignUp/home_src.dart';
// import 'package:smgi/pages/after_loginOrsignUp/home_src.dart';
// import 'package:smgi/utiles/snack_bar.dart';
import 'package:smgi_teacher/utils/snack_bar/snack_bar.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  // final googleIn = GoogleSignIn();
  final _formkey = GlobalKey<FormState>();
  final passwordcon = TextEditingController();
  final repasswordcon = TextEditingController();
  final namecon = TextEditingController();
  // final firestore = FirebaseFirestore.instance;

  final emailcon = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loding = false;
  String nameError = "";
  String emailError = "";
  String passError = "";
  String epassError = "";
  final year = DateTime.now();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      // Navigator.pop(context);
                    },
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        height: 30,
                        width: 32,
                        child: Image.asset("assets/image/back.png"),
                        // color: Colors.amber,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 110,
                  width: 212,
                  child: Image.asset("assets/image/logo.gif"),
                  // color: Colors.amber,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Welcome to SMGI",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Encode",
                        color: Color(0xFF161697),
                        decoration: TextDecoration.none),
                  ),
                ),
                const Text(
                  "LET ACCESS ALL WORK FROM HERE",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Encode",
                      color: Colors.black,
                      decoration: TextDecoration.none),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        SizedBox(
                            height: 40,
                            width: 250,
                            child: TextFormField(
                              controller: namecon,
                              decoration: InputDecoration(
                                  errorText:
                                      nameError.isNotEmpty ? nameError : null,
                                  fillColor: Colors.black12,
                                  filled: true,
                                  hintText: "Full Name",
                                  hintStyle: const TextStyle(
                                    fontFamily: "Encode",
                                    color: Colors.black87,
                                    // fontWeight: FontWeight.w600
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21))),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return;
                                } else if (value.length < 5) {
                                  return;
                                }
                                return null;
                              },
                            )),
                        const SizedBox(
                          height: 17,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19),
                              color: Colors.black12,
                            ),
                            height: 40,
                            width: 250,
                            child: TextFormField(
                              controller: emailcon,
                              decoration: InputDecoration(
                                  hintText: "Email Address",
                                  errorText:
                                      emailError.isNotEmpty ? emailError : null,
                                  hintStyle: const TextStyle(
                                    fontFamily: "Encode",
                                    color: Colors.black87,
                                    // fontWeight: FontWeight.w600
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21))),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return;
                                } else if (value.length < 6) {
                                  return;
                                }
                                return null;
                              },
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19),
                              color: Colors.black12,
                            ),
                            height: 40,
                            width: 250,
                            child: TextFormField(
                              controller: passwordcon,
                              onChanged: (value) {
                                passwordcon.text = value;
                              },
                              decoration: InputDecoration(
                                  errorText:
                                      passError.isNotEmpty ? passError : null,
                                  hintText: "Create Password",
                                  hintStyle: const TextStyle(
                                    fontFamily: "Encode",
                                    color: Colors.black87,
                                    // fontWeight: FontWeight.w600
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21))),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return;
                                } else if (value.length < 6) {
                                  return;
                                }
                                return null;
                              },
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19),
                              color: Colors.black12,
                            ),
                            height: 40,
                            width: 250,
                            child: TextFormField(
                              controller: repasswordcon,
                              onChanged: (value) {
                                repasswordcon.text = value;
                              },
                              decoration: InputDecoration(
                                  errorText:
                                      epassError.isNotEmpty ? epassError : null,
                                  hintText: "Re enter Password",
                                  hintStyle: const TextStyle(
                                    fontFamily: "Encode",
                                    color: Colors.black87,
                                    // fontWeight: FontWeight.w600
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21))),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return;
                                } else if (passwordcon.text !=
                                    repasswordcon.text) {
                                  return;
                                }
                                return null;
                              },
                            )),
                      ],
                    )),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () async {
                    try {
                      if (namecon.text.isEmpty ||
                          emailcon.text.isEmpty ||
                          passwordcon.text.isEmpty ||
                          repasswordcon.text.isEmpty) {
                        // NotValitedMsg();
                        emptyMsg();
                      } else if (namecon.text.length < 6 ||
                          emailcon.text.length < 6 ||
                          passwordcon.text.length < 6 ||
                          repasswordcon.text.length < 6) {
                        lengthCheckMsg();
                      } else if (passwordcon.text != repasswordcon.text) {
                        matchPassMsg();
                      } else {
                        if (checkEmail()) {
                          // UserCredential usercred =
                          //     await auth.createUserWithEmailAndPassword(
                          //         email: emailcon.text,
                          //         password: passwordcon.text);
                          // await usercred.user!
                          //     .sendEmailVerification()
                          //     .then((value) async {
                          // User user = auth.currentUser!;
                          // final studentData = student(

                          //   name: namecon.text,
                          //   uid: user.uid,
                          //   photourl: "",
                          //   email: emailcon.text,
                          //   password: passwordcon.text,
                          // ).toJson();
                          //   await firestore
                          //       .collection("student")
                          //       .doc(user.uid)
                          //       .set(studentData);
                          // });

                          succesMsg();
                          // Get.to(() => const VerifyEmailSrc(),
                          // transition: Transition.zoom);
                        } else {
                          snack_bar(
                              "Email",
                              "Enter A Valid Mail Or Check You Mail",
                              context,
                              ContentType.warning);
                        }
                      }
                    } catch (e) {
                      firebaseError(e);
                    }
                  },
                  child: Container(
                    height: 40.5,
                    width: 119.5,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(21),
                      // color: Colors.amberAccent,
                    ),
                    child: const Center(
                        child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 23,
                        fontFamily: "Encode",
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                        color: Color(0xFF161697),
                      ),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 1 / 2 - 120,
                      color: Colors.black,
                      height: 1,
                    ),
                    const Text(
                      "Continue with",
                      style: TextStyle(fontFamily: "Encode"),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 1 / 2 - 120,
                      color: Colors.black,
                      height: 1,
                    )
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                  child: SizedBox(
                      height: 40,
                      width: 42,
                      child: SizedBox(
                          child: Image.asset("assets/image/google.png"))),
                  onPressed: () async {
                    show();
                    // try {
                    //   GoogleSignInAccount? usercred = await googleIn.signIn();

                    //   GoogleSignInAuthentication? userauth =
                    //       await usercred?.authentication;
                    //   AuthCredential cred = GoogleAuthProvider.credential(
                    //     accessToken: userauth?.accessToken,
                    //     idToken: userauth?.idToken,
                    //   );
                    //   await auth.signInWithCredential(cred).then((value) {
                    //     snack_bar("Let's Go", "You Get In The App Successfully",
                    //         context, ContentType.success);
                    //     // Navigator.pushAndRemoveUntil(
                    //     //     context,
                    //     //     MaterialPageRoute(
                    //     //       builder: (context) => const HomeSrc(),
                    //     //     ),
                    //     //     (route) => false);
                    //   });

                    //   // print(user.user?.displayName);
                    // } catch (e) {
                    //   showwarning(e);
                    // }
                  },
                ),
                Image.asset(
                  "assets/image/2.png",
                  // fit: BoxFit.fill,
                )
              ],
            ),
          ),
        ),
      ),
    );
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

  void showwarning(e) {
    snack_bar("Your Phone Does Not Support At This Time Try Again Later",
        "Not Supported", context, ContentType.warning);
  }

  void show() {
    snack_bar("Wait !!", "Wait For A Second", context, ContentType.success);
  }

  void succesMsg() {
    snack_bar(
        "Yeah !", "Email Send To Your Mail", context, ContentType.success);
  }

  void emptyMsg() {
    snack_bar("Oops", "All Filed Must Be Filled", context, ContentType.failure);
  }

  void lengthCheckMsg() {
    snack_bar("Check Length", "All Filed Must Have Longer Than 6", context,
        ContentType.warning);
  }

  void matchPassMsg() {
    snack_bar(
        "Check Password", "It Should Be Same", context, ContentType.warning);
  }

  void firebaseError(Object e) {
    if (e is FirebaseAuthException) {
      snack_bar("Error!", e.message.toString(), context, ContentType.failure);
    } else {
      snack_bar("Error!", e.toString(), context, ContentType.failure);
    }
  }
}
