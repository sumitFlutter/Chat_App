import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/firebase_auth_helper.dart';
import '../../../utils/helpers/fire_db_helper.dart';
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
      body: FutureBuilder(
        future: FireDBHelper.helper.getAllContact(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (snapshot.hasData) {
            List<ProfileModel> clist = [];
            QuerySnapshot? q1 = snapshot.data;
              List<QueryDocumentSnapshot>? listq = q1?.docs;
              for (var x in listq!) {
                Map m1 = x.data() as Map;
                ProfileModel p1 = ProfileModel.mapToModel(m1,x.id);
                clist.add(p1);
              }
            return ListView.builder(
              itemCount: clist.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    await FireDBHelper.helper.getChat(AuthHelper.authHelper.user!.uid, clist[index].uid!);
                    Get.toNamed('chat',arguments: clist[index]);
                  },
                  child: ListTile(
                    leading:  CircleAvatar(radius: 30,child: Center(child: Text(clist[index].name!.substring(0,1).toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),),
                    title:Text("${clist[index].name}"),
                    subtitle: Text("${clist[index].about}"),
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
