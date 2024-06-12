import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../../utils/helpers/firebase_auth_helper.dart';
import '../../../utils/helpers/fire_db_helper.dart';
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
        leadingWidth: 125,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new,size: 20,)),
              const SizedBox(
                width: 4,
              ),
              CircleAvatar(
                radius: 25,
                child: Center(
                  child: Text(
                    model.name!.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: Text("${model.name}"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text("How to delete my specific Chat?"),
                  onTap: () {
                    Get.defaultDialog(
                        title: "How to delete my specific Chat?",
                        content: const Text(
                            "On Double tap of chat you can delete specific chat"),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text("OK!")),
                        ]);
                  },
                )
              ];
            },
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: Stack(
        children: [
          Obx(() => themeController.pTheme.value
              ? Image.asset(
                  "assets/background/dark.jpg",
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                )
              : Image.asset(
                  "assets/background/light1.jpg",
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                )),
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FireDBHelper.helper
                      .getLiveChat(AuthHelper.authHelper.user!.uid, model.uid!),
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
                                return InkWell(
                                    onDoubleTap: () {
                                      if (l1[index].uid ==
                                          AuthHelper.authHelper.user!.uid) {
                                        Get.defaultDialog(
                                            title: "Are you Sure?",
                                            content: const Text(
                                                "To delete this Chat"),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStateProperty.all(
                                                          Colors.red),
                                                ),
                                                child: const Text(
                                                  "No!",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  FireDBHelper.helper
                                                      .deleteChat(
                                                          l1[index].id!);
                                                  Get.back();
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStateProperty.all(
                                                            Colors.green)),
                                                child: const Text(
                                                  "Yes!",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ]);
                                      }
                                    },
                                    child: Container(
                                      alignment: l1[index].uid ==
                                              AuthHelper.authHelper.user!.uid
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        width: l1[index].msg!.length >= 60
                                            ? MediaQuery.sizeOf(context).width *
                                            0.45
                                            : l1[index].msg!.length >= 15
                                            ? MediaQuery.sizeOf(context)
                                            .width *
                                            0.30
                                            : MediaQuery.sizeOf(context)
                                            .width *
                                            0.20,

                                        margin: const EdgeInsets.all(10),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: themeController.pTheme.value
                                              ? l1[index].uid ==
                                              AuthHelper
                                                  .authHelper.user!.uid
                                              ? const Color(0xff005C4B)
                                              : const Color(0xff202C33)
                                              : l1[index].uid ==
                                              AuthHelper
                                                  .authHelper.user!.uid
                                              ? const Color(0xffD9FDD3)
                                              : Colors.grey.withOpacity(0.2),

                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Center(
                                              child: SelectableText(
                                                l1[index].msg!,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: l1[index].displayDate ==
                                                      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"
                                                  ? Text("${l1[index].time}")
                                                  : Text(
                                                      "${l1[index].displayDate}  ${l1[index].time}"),
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
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
                            time:
                                "${DateTime.now().hour}:${DateTime.now().minute}",
                            msg: txtMessage.text,
                            displayDate:
                                "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
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
        ],
      ),
    );
  }
}
