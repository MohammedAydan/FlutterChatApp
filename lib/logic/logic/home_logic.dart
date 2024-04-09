import 'package:chatapp/logic/logic/logic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeLogic {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future storeChat(String peerId, String lastMessageId) async {
    await _storeChat(auth.currentUser!.uid, peerId, lastMessageId);
    await _storeChat(peerId, auth.currentUser!.uid, lastMessageId);
  }

  static Future createChatGroup({
    required String groupId,
    required List<String> admins,
    required List<String> members,
  }) async {
    await _createChatGroup(
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChats() {
    return firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("friends")
        // .collection("chats")
        .orderBy("created_at", descending: true)
        .snapshots();
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

  static Future _storeChat(
      String userId, String peerId, String lastMessageId) async {
    await firestore
        .collection("users")
        .doc(userId)
        .collection("chats")
        .doc(ChatLogic.getChatId(userId, peerId))
        .set({
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
    await firestore
        .collection("users")
        .doc(userId)
        .collection("chats")
        .doc(groupId)
        .update({
      "last_message_id": lastMessageId,
      "user_id": userId,
      "group_id": groupId,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  static Future _createChatGroup({
    required String userId,
    required String groupId,
    required List<String> admins,
    required List<String> members,
  }) async {
    await firestore
        .collection("users")
        .doc(userId)
        .collection("chats")
        .doc(groupId)
        .set({
      "owner_id": userId,
      "admins": admins,
      "members": members,
      "last_message_id": null,
      "user_id": userId,
      "group_id": groupId,
      "created_at": DateTime.now().toIso8601String(),
    });
    for (String member in members) {
      if (member != userId) {
        await firestore
            .collection("users")
            .doc(member)
            .collection("chats")
            .doc(groupId)
            .set({
          "owner_id": userId,
          "admins": admins,
          "members": members,
          "last_message_id": null,
          "user_id": userId,
          "group_id": groupId,
          "created_at": DateTime.now().toIso8601String(),
        });
      }
    }
  }
}
