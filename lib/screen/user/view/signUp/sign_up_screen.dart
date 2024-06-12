import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
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
        body:Stack(
          children: [
                  Image.asset("assets/background/dark.jpg",height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,),

            SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),),
                      const SizedBox(height: 12,),
                      TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            hintText: "Email"),
                        controller: txtEmail,
                      ),
                      const SizedBox(height: 8,),
                      TextField(style: TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            hintText: "Password"),
                        controller: txtPass,
                        obscureText: true,
                      ),
                      const SizedBox(height: 16,),
                      ElevatedButton(onPressed: () async {
                        String msg = await AuthHelper.authHelper.signUp(
                            emailAddress: txtEmail.text, password: txtPass.text);
                        if (msg == "Success") {
                          Get.offAllNamed("SignIn");
                        }
                        else {
                          Get.snackbar("Chat App", msg);
                        }
                      }, style:ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.2))),child: const Text("Sign Up",style: TextStyle(color: Colors.white),)),
                      const SizedBox(height: 12,),
                      TextButton(onPressed: () {
                        Get.offAllNamed("SignIn");
                      }, child: const Text("Have a Account? Sign In",style: TextStyle(color:Colors.white),)),
                                    ],
                  ),
                ),
              ),
            ),
                  ),
          ],
        ),
      ),
    );
  }
}
