
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../utils/helpers/firebase_auth_helper.dart';
import '../../../../utils/helpers/fire_db_helper.dart';
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
  TextEditingController txtAbout = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
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
         String profile=m1['about'];
         String email=m1['email'];
         String number=m1['number'];
         String uid=m1['uid'];
         txtName.text=name;
         txtAbout.text=profile;
         txtNumber.text=number;
         txtEmail.text=email;
       }
                         else{
       txtAbout.text="Hi! There I am using Galaxy Chat.";
                         }
                        return SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: key,
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
                        return"Name is required";
                      }
                      return null;
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
                        return "Mobile number is required";
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
                      return null;
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
                    controller: txtAbout,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.info),
                        label: Text("about")),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if(key.currentState!.validate())
                        {
                          ProfileModel model = ProfileModel(
                            name: txtName.text,
                            email: txtEmail.text,
                            number: txtNumber.text,
                            about: txtAbout.text,
                          );
                          await FireDBHelper.helper.userProfile(model);
                         await FireDBHelper.helper.getCurrentUser();
                          Get.offAllNamed('home');
                        }

                    },
                    child: const Text("save"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
                        );
                       }
                     return const Center(child: CircularProgressIndicator());
                  },
                )
    );
  }
}