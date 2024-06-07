import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/helpers/firebase_auth_helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/logo/logo.png",
                    height:100,
                    width: 100,
                    fit:BoxFit.cover,
                  ),
                  SizedBox(height: 16,),
                  const Text("Sign Up",
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
                    String msg = await AuthHelper.authHelper.signUp(
                        emailAddress: txtEmail.text, password: txtPass.text);
                    if (msg == "Success") {
                      Get.offAllNamed("signIn");
                    }
                    else {
                      Get.snackbar("Chat App", msg);
                    }
                  }, child: const Text("Sign Up")),
                  const SizedBox(height: 12,),
                  TextButton(onPressed: () {
                    Get.offAllNamed("signIn");
                  }, child: const Text("Have a Account? Sign In")),
                                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
