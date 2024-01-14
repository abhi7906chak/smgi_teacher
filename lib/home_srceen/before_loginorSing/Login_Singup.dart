import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smgi_teacher/home_srceen/before_loginorSing/login_page.dart';
import 'package:smgi_teacher/home_srceen/before_loginorSing/singup_page.dart';
// import 'package:smgi/pages/login_page.dart';
// import 'package:smgi/pages/singup_page.dart';

class LoginSingUpPage extends StatefulWidget {
  const LoginSingUpPage({super.key});

  @override
  State<LoginSingUpPage> createState() => _LoginSingUpPageState();
}

class _LoginSingUpPageState extends State<LoginSingUpPage> {
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
                SizedBox(
                  height: 110,
                  width: 212,
                  child: Image.asset("assets/image/logo.gif"),
                  // color: Colors.amber,
                ),
                // const SizedBox(
                //   height: ,
                // ),
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
                  height: 28,
                ),
                InkWell(
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
                  onTap: () {
                    Get.to(() => const LoginPageSrc(),
                        transition: Transition.leftToRightWithFade);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => const SingUpPage(),
                        transition: Transition.leftToRightWithFade);
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
                        fontSize: 20,
                        fontFamily: "Encode",
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                        color: Color(0xFF161697),
                      ),
                    )),
                  ),
                ),
                SizedBox(
                  child: Image.asset("assets/image/0.png"),
                  // height: MediaQuery.of(context).size.height,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
