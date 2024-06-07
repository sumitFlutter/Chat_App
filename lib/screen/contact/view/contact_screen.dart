import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/firebase_auth_helper.dart';
import '../../../utils/helpers/firedb_helper.dart';
import '../../user/model/profile_model.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("contact"),
      ),
      body: StreamBuilder(
        stream: FireDBHelper.helper.allContact(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (snapshot.hasData) {
            List<ProfileModel> list = [];
            QuerySnapshot? q1 = snapshot.data;
              List<QueryDocumentSnapshot>? listq = q1?.docs;
              for (var x in listq!) {
                Map m1 = x.data() as Map;
                ProfileModel p1 = ProfileModel.mapToModel(m1,x.id);
                list.add(p1);
              }
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    await FireDBHelper.helper.getChat(AuthHelper.authHelper.user!.uid, list[index].uid!);
                    Get.toNamed('chat',arguments: list[index]);
                  },
                  child: ListTile(
                    leading: const CircleAvatar(radius: 30,),
                    title:Text("${list[index].name}"),
                    subtitle: Text("${list[index].number}"),
                  ),
                );
              },
            );
          }
          return  const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
