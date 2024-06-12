import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../utils/helpers/firebase_auth_helper.dart';

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
        body: Stack(
          children: [
                  Image.asset("assets/background/dark.jpg",height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,),
            SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
                child:Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                      TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            hintText: "Password"),
                        controller: txtPass,
                        obscureText: true,
                      ),
                      const SizedBox(height: 16,),
                      ElevatedButton(style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.2))),
                          onPressed: () async {
                        String msg = await AuthHelper.authHelper.signIn(
                            emailAddress: txtEmail.text, password: txtPass.text);
                        if (msg == "Success") {
                          AuthHelper.authHelper.checkUser();
                          Get.offAllNamed("profile");
                        }
                        else {
                          Get.snackbar("Chat App", msg);
                        }
                      }, child: const Text("Sign In",style: TextStyle(color: Colors.white),)),
                      SizedBox(height: 16,),
                      TextButton.icon(onPressed: () async {
                        await AuthHelper.authHelper.signInWithGoogle().then((value) {
                          AuthHelper.authHelper.checkUser();
                          Get.offAllNamed("profile");
                        },);
                      }, label: const Text("Continue with Google!",style: TextStyle(color: Colors.white),),
                      icon: Image.asset("assets/logo/google.png",height: 24,width: 24,fit: BoxFit.cover,),),
                      const SizedBox(height: 16,),
                      TextButton.icon(onPressed: () async {
                        String msg = await AuthHelper.authHelper.guestLogIn();
                        if (msg == "Success") {
                          AuthHelper.authHelper.checkUser();
                          Get.offAllNamed("profile");
                        }
                        else {
                          Get.snackbar("Chat App", msg);
                        }
                      }, label: const Text("Or Sign In as Guest",style: TextStyle(color: Colors.white),),icon: Icon(Icons.person_add,color: Colors.white,),),
                      const SizedBox(height: 20,),
                      TextButton(onPressed: () {
                        Get.offAllNamed("signUp");
                      }, child: const Text("Don't have Account? Sign Up",style: TextStyle(color: Colors.white),)),
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
