import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smgi_teacher/home_srceen/after_login/Home/home_src.dart';
import 'package:smgi_teacher/home_srceen/before_loginorSing/log_in/forgot_password/password.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:smgi/pages/after_loginOrsignUp/home_src.dart';
// import 'package:smgi/pages/forget_pass/password.dart';
// import 'package:smgi/utiles/snack_bar.dart';
import 'package:smgi_teacher/utils/snack_bar/snack_bar.dart';

class LoginPageSrc extends StatefulWidget {
  const LoginPageSrc({super.key});

  @override
  State<LoginPageSrc> createState() => _LoginPageSrcState();
}

class _LoginPageSrcState extends State<LoginPageSrc> {
  final _formkey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  bool gmailbutton = false;
  // final googleIn = GoogleSignIn();
  final emailcon = TextEditingController();
  final passcon = TextEditingController();

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
                const SizedBox(
                  height: 10,
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
                                  contentPadding:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21))),
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
                              controller: passcon,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: const TextStyle(
                                    fontFamily: "Encode",
                                    color: Colors.black87,
                                    // fontWeight: FontWeight.w600
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21))),
                            )),
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      // color: Colors.amber,
                      height: 34,
                      width: 250,
                      child: TextButton(
                          onPressed: () {
                            Get.to(()=> const FpassWord());
                          },
                          child: const Text(
                            "Forget Password ?",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Encode",
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    try {
                      if (emailcon.text.isEmpty || passcon.text.isEmpty) {
                        snack_bar("Ooh No !!", "All Filed Must Be Filled",
                            context, ContentType.warning);
                      } else if (emailcon.text.length < 6 ||
                          passcon.text.length < 6) {
                        snack_bar(
                            "check Length",
                            "All Filed Should Be Greater Than 6",
                            context,
                            ContentType.warning);
                      } else {
                        show();
                        if (checkEmail()) {
                          await auth
                              .signInWithEmailAndPassword(
                                  email: emailcon.text, password: passcon.text)
                              // .onError((error, stackTrace) => snk(error))
                              .then((value) {
                            snack_bar("Yeah!!", "Let's Rock !!", context,
                                ContentType.success);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Homesrc(),
                                ),
                                (route) => false);
                          });
                        }
                      }
                    } catch (e) {
                      firewarnig(e);
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
                      "Login",
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Container(
                //       width: MediaQuery.of(context).size.width * 1 / 2 - 120,
                //       color: Colors.black,
                //       height: 1,
                //     ),
                //     const Text(
                //       "Continue with",
                //       style: TextStyle(fontFamily: "Encode"),
                //     ),
                //     Container(
                //       width: MediaQuery.of(context).size.width * 1 / 2 - 120,
                //       color: Colors.black,
                //       height: 1,
                //     )
                //   ],
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // ElevatedButton(
                //   style: ButtonStyle(
                //       elevation: MaterialStateProperty.all(0),
                //       backgroundColor: MaterialStateProperty.all(Colors.white)),
                //   child: SizedBox(
                //       height: 40,
                //       width: 42,
                //       child: SizedBox(
                //           child: Image.asset("assets/image/google.png"))),
                //   onPressed: () async {
                //     show();
                //     try {
                //       GoogleSignInAccount? usercred = await googleIn.signIn();

                //       GoogleSignInAuthentication? userauth =
                //           await usercred?.authentication;
                //       AuthCredential cred = GoogleAuthProvider.credential(
                //         accessToken: userauth?.accessToken,
                //         idToken: userauth?.idToken,
                //       );
                //       await auth.signInWithCredential(cred).then((value) {
                //         snack_bar("Let's Go", "You Get In The App Successfully",
                //             context, ContentType.success);
                //         // Navigator.pushAndRemoveUntil(
                //         //     context,
                //         //     MaterialPageRoute(
                //         //       builder: (context) => const HomeSrc(),
                //         //     ),
                //         //     (route) => false);
                //       });

                //     } catch (e) {
                //       showwarning(e);
                //     }
                //   },
                // ),
                Image.asset("assets/image/1.png"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showwarning(e) {
    snack_bar("Your Phone Does Not Support At This Time Try Again Later",
        "Not Supported", context, ContentType.warning);
  }

  void show() {
    snack_bar("Wait !!", "Wait For A Second", context, ContentType.success);
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

  snk(error) {
    snack_bar(error.toString(), "error", context, ContentType.failure);
  }

  void firewarnig(e) {
    if (e is FirebaseAuthException) {
      snack_bar("Error", e.message.toString(), context, ContentType.warning);
    } else {
      snack_bar("Error !!", "Check Your Internet Conection Or Try Again",
          context, ContentType.failure);
    }
  }
}
