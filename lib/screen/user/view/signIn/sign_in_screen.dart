import 'dart:io';

import 'package:chat_app_6099/utils/helpers/firebase_auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: "logo",
                  child: Image.asset(
                    "assets/logo/logo.png",
                    height:100,
                    width: 100,
                    fit:BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16,),
                const Text("Sign In",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                const SizedBox(height: 12,),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Your Email to Sign In"),
                  controller: txtEmail,
                ),
                const SizedBox(height: 8,),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Your Password to Sign In"),
                  controller: txtPass,
                ),
                const SizedBox(height: 16,),
                ElevatedButton(onPressed: () async {
                  String msg = await AuthHelper.authHelper.signIn(
                      emailAddress: txtEmail.text, password: txtPass.text);
                  if (msg == "Success") {
                    Get.offAllNamed("profile");
                  }
                  else {
                    Get.snackbar("Chat App", msg);
                  }
                }, child: const Text("Sign In")),
                const SizedBox(height: 12,),
                TextButton(onPressed: () {
                  Get.offAllNamed("signUp");
                }, child: const Text("Don't have Account? Sign Up")),
                SizedBox(height: 16,),
                TextButton.icon(onPressed: () async {
                  await AuthHelper.authHelper.signInWithGoogle().then((value) {
                    AuthHelper.authHelper.checkUser();
                    Get.offAllNamed("profile");
                  },);
                }, label: const Text("Continue with Google!"),
                icon: Image.asset("assets/logo/google.png",height: 24,width: 24,fit: BoxFit.cover,),),
                const SizedBox(height: 16,),
                ElevatedButton(onPressed: () async {
                  String msg = await AuthHelper.authHelper.guestLogIn();
                  if (msg == "Success") {
                    Get.offAllNamed("profile");
                  }
                  else {
                    Get.snackbar("Chat App", msg);
                  }
                }, child: const Text("Or Sign In as Guest")),
                    
              ],
            ),
          ),
        ),
      ),
    );
  }
}
