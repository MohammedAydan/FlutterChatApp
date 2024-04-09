import 'package:chatapp/logic/logic/logic.dart';
import 'package:chatapp/logic/models/chat_model_f.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class HomeLogicV2 {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future storeChat(String peerId, String lastMessageId) async {
    await _storeChat(auth.currentUser!.uid, peerId, lastMessageId);
  }

  static Future createChatGroup({
    required String displayName,
    required String imgUrl,
    required String groupId,
    required List<String> admins,
    required List<String> members,
  }) async {
    await _createChatGroup(
      displayName: displayName,
      imgUrl: imgUrl,
      userId: auth.currentUser!.uid,
      groupId: groupId,
      admins: admins,
      members: members,
    );
  }

  static Future storeChatGroup(
    String groupId, {
    String? lastMessageId,
  }) async {
    await _storeChatGroup(
      auth.currentUser!.uid,
      groupId,
      lastMessageId: lastMessageId,
    );
  }

  static Future addNewUserForGroup(
    String userId,
    bool isAdmin,
    String groupId,
  ) async {
    await _addNewUserChatGroup(
      userId: userId,
      isAdmin: isAdmin,
      groupId: groupId,
    );
  }

  static Stream getChatsV2() {
    return firestore
        .collection("chats")
        .where("members", arrayContains: auth.currentUser?.uid)
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChats() {
    var currentUser = FirebaseAuth.instance.currentUser;

    var usersQuery1 = FirebaseFirestore.instance
        .collection("chats")
        .where("user_id", isEqualTo: currentUser?.uid)
        .orderBy("created_at", descending: true)
        .snapshots();

    var usersQuery2 = FirebaseFirestore.instance
        .collection("chats")
        .where("r_user_id", isEqualTo: currentUser?.uid)
        .orderBy("created_at", descending: true)
        .snapshots();

    var groupsQuery = FirebaseFirestore.instance
        .collection("chats")
        .where("members", arrayContains: currentUser?.uid)
        .orderBy("created_at", descending: true)
        .snapshots();

    final mergedStream = Rx.merge([usersQuery1, usersQuery2, groupsQuery]);

    return mergedStream;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getMessageById(
    String userId,
    String peerId,
    String lastMessageId,
  ) {
    return firestore
        .collection("chats")
        .doc(ChatLogic.getChatId(userId, peerId))
        .collection("messages")
        .doc(lastMessageId)
        .snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getMessageByIdForGroup(
    String groupId,
    String lastMessageId,
  ) {
    return firestore
        .collection("chats")
        .doc(groupId)
        .collection("messages")
        .doc(lastMessageId)
        .snapshots();
  }

  static Future _storeChat(
      String userId, String peerId, String lastMessageId) async {
    await firestore
        .collection("chats")
        .doc(ChatLogic.getChatId(userId, peerId))
        .set({
      "type": "user", // "user" or "group"
      "last_message_id": lastMessageId,
      "user_id": userId,
      "r_user_id": peerId,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  static Future _storeChatGroup(
    String userId,
    String groupId, {
    String? lastMessageId,
  }) async {
    await firestore.collection("chats").doc(groupId).update({
      "last_message_id": lastMessageId,
      "user_id": userId,
      "group_id": groupId,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  static Future _createChatGroup({
    required String displayName,
    required String imgUrl,
    required String userId,
    required String groupId,
    required List<String> admins,
    required List<String> members,
  }) async {
    await firestore.collection("chats").doc(groupId).set({
      "type": "group", // "user" or "group"
      "displayName": displayName,
      "imgUrl": imgUrl,
      "owner_id": userId,
      "admins": admins,
      "members": members,
      "last_message_id": null,
      "user_id": userId,
      "group_id": groupId,
      "r_user_id": null,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  static Future _addNewUserChatGroup({
    required String userId,
    required bool isAdmin,
    required String groupId,
  }) async {
    if (isAdmin) {
      await firestore.collection("chats").doc(groupId).update({
        "admins": FieldValue.arrayUnion([userId]),
        "members": FieldValue.arrayUnion([userId]),
      });
    } else {
      await firestore.collection("chats").doc(groupId).update({
        "members": FieldValue.arrayUnion([userId]),
      });
    }
  }
}
