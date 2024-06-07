import 'package:chat_app_6099/screen/user/model/profile_model.dart';
import 'package:chat_app_6099/utils/helpers/fcm_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../screen/chat/model/chat_model.dart';
import 'firebase_auth_helper.dart';

class FireDBHelper {
  static FireDBHelper helper = FireDBHelper._();

  FireDBHelper._();

  var db = FirebaseFirestore.instance;
  String? chatId ;
  ProfileModel? currentUser;

  Future<void> userProfile(ProfileModel model) async {
    await db.collection("user").doc(AuthHelper.authHelper.user!.uid).set({
      "name": model.name,
      "email": model.email,
      "profile": model.profile,
      "number": model.number,
      "uid": model.uid,
      "token":FCMHelper.fcm.token
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile() {
    return db.collection("user").doc(AuthHelper.authHelper.user!.uid).get();
  }
  Future<QuerySnapshot<Map<String, dynamic>>> getData()
  {
    return db
        .collection("chat")
        .where("uid", arrayContainsAny: [AuthHelper.authHelper.user!.uid])
        .get();
  }
  Future<void> getCurrentUser()
  async {
    DocumentSnapshot ds =await db.collection("user").doc(AuthHelper.authHelper.user!.uid).get();
    Map m1=ds.data()as Map;
    currentUser=ProfileModel.mapToModel(m1, AuthHelper.authHelper.user!.uid);

  }

  Stream<QuerySnapshot<Map<String, dynamic>>> allContact() {
    return db
        .collection("user")
        .where("uid", isNotEqualTo: AuthHelper.authHelper.user!.uid)
        .snapshots();
  }

  Future<void> sendMessage(ChatModel model, ProfileModel p1) async {
    if (chatId!=null) {
      AddMessage(chatId!, model, p1);
    } else {
      chatId = await addChatUID(p1);
      AddMessage(chatId!, model, p1);
    }
  }

  Future<void> AddMessage(
      String docId, ChatModel model, ProfileModel p1) async {
    await db.collection("chat").doc(docId).collection("msg").add({
      "date": "${model.date}",
      "time": "${model.time}",
      "uid": AuthHelper.authHelper.user!.uid,
      "msg": "${model.msg}"
    });
  }

  Future<String> addChatUID(ProfileModel p1) async {
    DocumentReference reference = await db.collection("chat").add({
      "uid": [p1.uid, AuthHelper.authHelper.user!.uid],
      "name":[p1.name,currentUser!.name],
      "number":[p1.number,currentUser!.number],
      "email":[p1.email,currentUser!.email],
      "profile":[p1.profile,currentUser!.profile]
    });
    return reference.id;
  }
  Future<void> getChat(String myUid,String userUid)
  async {
    QuerySnapshot qs=await db.collection("chat").where("uid",arrayContainsAny: [myUid,userUid]).get();
    List<DocumentSnapshot>dsList=qs.docs.where((e) {
      List uids=e['uid'];
      if(uids.contains(myUid) && uids.contains(userUid))
      {
        return true;
      }
      return false;
    },).toList();
    if(dsList.isNotEmpty)
    {
      chatId=dsList[0].id;
    }
    else
    {
      chatId=null;
    }
  }
  Stream<QuerySnapshot<Map<String, dynamic>>>? getchat(String myUid,String userUid)
  {
    if (chatId!=null) {
      return  db.collection("chat").doc(chatId).collection("msg").orderBy("date").snapshots();
    }
    return null;
  }
}
