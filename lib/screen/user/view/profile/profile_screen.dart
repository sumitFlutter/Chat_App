import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/helpers/firebase_auth_helper.dart';
import '../../../../utils/helpers/firedb_helper.dart';
import '../../model/profile_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtNumber = TextEditingController();
  TextEditingController txtProfile = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:FutureBuilder(
        future: FireDBHelper.helper.getUserProfile(),
        builder: (context, snapshot) {
           if(snapshot.hasError)
            {
              return Text("${snapshot.error}");
            }
           else if(snapshot.hasData)
             {
               DocumentSnapshot? d1=snapshot.data;
               Map? m1=d1?.data() as Map?;
               if(m1 != null)
                 {
                   String name=m1['name'];
                   String profile=m1['profile'];
                   String email=m1['email'];
                   String number=m1['number'];
                   String uid=m1['uid'];
                   txtName.text=name;
                   txtProfile.text=profile;
                   txtNumber.text=number;
                   txtEmail.text=email;
                 }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        "Your profile",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: txtName,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if(value!.isEmpty)
                          {
                            return"required";
                          }
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          label: Text("name"),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: txtNumber,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if(value!.isEmpty)
                          {
                            return "required";
                          }
                          else if(value.length !=10)
                          {
                            return"Please valid number";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.call),
                          label: Text("number"),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: txtEmail,
                        validator: (value) {
                          if(value!.isEmpty)
                          {
                            return"required";
                          }
                          else if(value!.isEmpty)
                          {
                            return "^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))";

                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                          label: Text("email"),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if(value!.isEmpty)
                          {
                            return"required";
                          }
                        },
                        controller: txtProfile,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.image),
                            label: Text("profile")),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          ProfileModel model = ProfileModel(
                              name: txtName.text,
                              email: txtEmail.text,
                              number: txtNumber.text,
                              profile: txtProfile.text,
                            uid: AuthHelper.authHelper.user!.uid,
                          );
                          await FireDBHelper.helper.userProfile(model);
                          Get.offAllNamed('home');
                        },
                        child: const Text("save"),
                      ),
                    ],
                  ),
                ),
              );
             }
           return Center(child: CircularProgressIndicator());
        },
      )
    );
  }
}