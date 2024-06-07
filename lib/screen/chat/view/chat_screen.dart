
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/firebase_auth_helper.dart';
import '../../../utils/helpers/firedb_helper.dart';
import '../../user/model/profile_model.dart';
import '../model/chat_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ProfileModel model = Get.arguments;
  TextEditingController txtMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(5.0),
          child: CircleAvatar(),
        ),
        title: Text("${model.name}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FireDBHelper.helper
                  .getchat(AuthHelper.authHelper.user!.uid, model.uid!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else if (snapshot.hasData) {
                  List<ChatModel> l1 = [];
                  QuerySnapshot? qs = snapshot.data;
                  List<QueryDocumentSnapshot>? qsList = qs?.docs;
                  for (var x in qsList!) {
                    String id = x.id;
                    Map? m1 = x.data() as Map;
                    ChatModel chat = ChatModel.mapToModel(m1, id);
                    l1.add(chat);
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: l1.length,
                          itemBuilder: (context, index) {
                            return Container(
                              alignment:
                                  l1[index].uid == AuthHelper.authHelper.user!.uid
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: 100,
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade100,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                ),
                                child: Text("${l1[index].msg}"),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: txtMessage,
              decoration: InputDecoration(
                hintText: "Type",
                suffixIcon: IconButton(
                  onPressed: () {
                    ChatModel c1 = ChatModel(
                        uid: AuthHelper.authHelper.user!.uid,
                        date: "${DateTime.now()}",
                        time: "${TimeOfDay.now()}",
                        msg: txtMessage.text);
                    txtMessage.clear();
                    FireDBHelper.helper.sendMessage(c1, model);
                  },
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
