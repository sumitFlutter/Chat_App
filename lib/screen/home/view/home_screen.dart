
import 'package:chat_app_6099/utils/service/notification_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../../utils/helpers/firebase_auth_helper.dart';
import '../../../utils/helpers/firedb_helper.dart';
import '../../user/model/profile_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FireDBHelper.helper.getCurrentUser();
    FireDBHelper.helper.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              NotificationService.service.schedulingNotification(title: 'hi',msg: "hi i am developer");
            },
            icon: const Icon(Icons.timer),
          ),
          IconButton(
            onPressed: () {
              NotificationService.service.showNotification(title: 'hi',body: "hi i am developer");
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: FutureBuilder(
        future: FireDBHelper.helper.getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (snapshot.hasData) {
            List<ProfileModel> l1 = [];
            QuerySnapshot? qs = snapshot.data;
            List<QueryDocumentSnapshot> qList = qs!.docs;
            for (var x in qList) {
              Map m1 = x.data() as Map;
              List uids = m1['uid'];
              List name = m1['name'];
              List email = m1['email'];
              List number = m1['number'];
              List profile = m1['profile'];
              String uid = "";
              String name1 = "";
              String email1 = "";
              String number1 = "";
              String profile1 = "";
              if (uids[0] == AuthHelper.authHelper.user!.uid) {
                uid = uids[1];
                name1 = name[1];
                email1 = email[1];
                number1 = number[1];
                profile1 = profile[1];
              } else {
                uid = uids[0];
                name1 = name[0];
                email1 = email[0];
                number1 = number[0];
                profile1 = profile[0];
              }

              ProfileModel p1 = ProfileModel(
                name: name1,
                uid: uid,
                email: email1,
                number: number1,
                profile: profile1,
              );

              l1.add(p1);
            }
            return ListView.builder(
              itemCount: l1.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    await FireDBHelper.helper.getChat(AuthHelper.authHelper.user!.uid, l1[index].uid!);
                    Get.toNamed('chat',arguments: l1[index]);
                  },
                  child: ListTile(
                    leading: const CircleAvatar(radius: 30,),
                    title:Text("${l1[index].name}"),
                    subtitle: Text("${l1[index].number}"),
                  ),
                );
              },
            );
          }
        return Container();
        },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('contact');
        },
        child: const Icon(Icons.chat),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    FirebaseAuth.instance.currentUser!.photoURL == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                "${FirebaseAuth.instance.currentUser!.photoURL}"),
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                    Visibility(
                        visible:
                            FirebaseAuth.instance.currentUser!.displayName !=
                                null,
                        child: Text(
                          "${FirebaseAuth.instance.currentUser!.displayName}",
                          style: const TextStyle(fontSize: 18),
                        )),
                    TextButton(
                        onPressed: () {
                          Get.toNamed('profile');
                        },
                        child: Text(
                          "${FirebaseAuth.instance.currentUser!.email}",
                          style: const TextStyle(fontSize: 18),
                        )),
                  ],
                ),
              ),
              ListTile(
                leading: IconButton(
                    onPressed: () {
                      themeController.setTheme();
                    },
                    icon: Obx(() => Icon(themeController.themeMode.value))),
                title: const Text("Change Theme"),
              ),
              SizedBox(height: 12,),
              ListTile(
                onTap: () {
                  AuthHelper.authHelper.logOut();
                  Get.toNamed('SignIn');
                },
                title: const Text("Logout"),
                leading: const Icon(Icons.logout_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
