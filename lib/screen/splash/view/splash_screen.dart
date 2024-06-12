import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../../utils/helpers/fire_db_helper.dart';
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
  if(isRight)
    {
      getUC();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
                Image.asset("assets/background/dark.jpg",height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,),
          SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: Center(
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
          ),
        ],
      ),
    );
  }
  Future<void> getUC()
  async {
    await FireDBHelper.helper.getCurrentUser();
  }
}
