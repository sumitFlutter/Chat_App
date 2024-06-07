import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/firebase_auth_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isRight=AuthHelper.authHelper.checkUser();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3),() => Get.offAllNamed( isRight?"home":"SignIn"),);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Center(
          child: Hero(
            tag: "logo",
            child: Image.asset(
            "assets/logo/logo.png",
            height:125,
            width: 125,
              fit:BoxFit.cover,
            ),
          ),
        ),
        ],
      ),
    );
  }
}
