import 'package:chatapp/logic/logic/logic.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Logic2 {
  static User? user = FirebaseAuth.instance.currentUser;
  static CollectionReference usersDb =
      FirebaseFirestore.instance.collection("users");
  static CollectionReference statusUserDb =
      FirebaseFirestore.instance.collection("status");
  static CollectionReference chatsDb =
      FirebaseFirestore.instance.collection("chats");

  static Stream<QuerySnapshot<Map<String, dynamic>>> getFirends() {
    return usersDb.doc(user!.uid).collection("chats").snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      String peerId) {
    return chatsDb
        .doc(ChatLogic.getChatId(user!.uid, peerId))
        .collection("messages")
        .orderBy("created_at", descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<UserModel?> getUser(String uid) async {
    final res = await usersDb.doc(uid).get();
    return UserModel.fromJson(res.data() as Map<String, dynamic>);
  }
}
