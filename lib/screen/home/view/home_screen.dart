
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../../utils/helpers/firebase_auth_helper.dart';
import '../../../utils/helpers/fire_db_helper.dart';
import '../../../utils/service/notification_helper.dart';
import '../../user/model/profile_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() =>
            Text("Galaxy Chat",style: TextStyle(color:themeController.pTheme.value==false?const Color(0xff005C4B):Colors.white),)),
        actions: [
          IconButton(
            onPressed: () {
              NotificationService.service.schedulingNotification(title: 'testing notification',msg: "hi my name is sumit!");
            },
            icon: const Icon(Icons.timer),
          ),
          IconButton(
            onPressed: () {
              NotificationService.service.showNotification(title: 'testing notification',body: "hi my name is sumit!");
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FireDBHelper.helper.getRecentChatData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (snapshot.hasData) {
            List<ProfileModel> l1 = [];
            QuerySnapshot? qs = snapshot.data;
            List<QueryDocumentSnapshot> qList = qs!.docs;
            for (var x in qList) {
              Map m1 = x.data() as Map;
              List uidS = m1['uid'];
              List name = m1['name'];
              List email = m1['email'];
              List number = m1['number'];
              List about = m1['about'];
              String uid = "";
              String name1 = "";
              String email1 = "";
              String number1 = "";
              String about1 = "";
              if (uidS[0] == AuthHelper.authHelper.user!.uid) {
                uid = uidS[1];
                name1 = name[1];
                email1 = email[1];
                number1 = number[1];
                about1 = about[1];
              } else {
                uid = uidS[0];
                name1 = name[0];
                email1 = email[0];
                number1 = number[0];
                about1 = about[0];
              }

              ProfileModel p1 = ProfileModel(
                name: name1,
                uid: uid,
                email: email1,
                number: number1,
                about: about1,
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
                    leading: CircleAvatar(radius: 30,child: Center(child: Text(l1[index].name!.substring(0,1).toUpperCase(),style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),),
                    title:Text("${l1[index].name}"),
                    subtitle: Text("${l1[index].about}"),
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10,),
            FirebaseAuth.instance.currentUser!.photoURL == null
                  ? CircleAvatar(
                radius: 50,
                child: Center(child: Text(FireDBHelper.helper.currentUser.name!.substring(0,1).toUpperCase(),style: const TextStyle(fontSize: 50,fontWeight: FontWeight.w500),),),)
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
              Visibility(
            visible:
            FirebaseAuth.instance.currentUser!.displayName !=
                null,
            child: const Divider(),),
              Visibility(
                visible:
                FirebaseAuth.instance.currentUser!.displayName !=
                    null,
                child: const SizedBox(height: 4,),),
              Visibility(
                  visible:FirebaseAuth.instance.currentUser!.email !=
                      null,
                  child:
                  Text(
                    "${FirebaseAuth.instance.currentUser!.email}",
                    style: const TextStyle(fontSize: 18),
                  )),
          Visibility(
            visible:FirebaseAuth.instance.currentUser!.email !=
                null,
            child:
            const Divider()),
              Visibility(
                  visible:FirebaseAuth.instance.currentUser!.email !=
                      null,
                  child:
                  const SizedBox(height: 4,)),
              Text(FireDBHelper.helper.currentUser.about!),
              const Divider(),
              const SizedBox(height: 4,),
              Center(child: TextButton.icon(onPressed: () {
                Get.toNamed("profile");
              }, label: const Text("Edit Profile"),icon: const Icon(Icons.edit),),),
              const SizedBox(height: 12,),
              ListTile(
                onTap: () {
                  themeController.setTheme();
                },
                leading:  Obx(() => Icon(themeController.themeMode.value)),
                title: const Text("Change Theme"),
              ),
              const SizedBox(height: 12,),
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
