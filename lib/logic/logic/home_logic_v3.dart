import 'package:chatapp/logic/logic/auth_logic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class HomeLogicV3 {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  // static Future autoDBChat(String peerId, String lastMessageId){

  //       if (message.isEmpty) {
  //         await HomeLogicV3.storeChat(rUser.uid, msg!.id!);
  //       } else {
  //         await HomeLogicV3.updateChat(rUser.uid, msg!.id!);
  //       }
  // }

  static Future storeChat(String peerId, String lastMessageId) async {
    await _storeChat(peerId, lastMessageId);
  }

  static Future updateChat(String peerId, String lastMessageId) async {
    await _updateChat(peerId, lastMessageId);
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
      groupId: groupId,
      admins: admins,
      members: members,
    );
  }

  static Future updateChatGroup(
    String groupId, {
    String? lastMessageId,
  }) async {
    await _storeChatGroup(
      groupId,
      lastMessageId: lastMessageId,
    );
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChats() {
    return firestore
        .collection("chats")
        .where("members", arrayContains: auth.currentUser?.uid)
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  static Future _storeChat(
    String peerId,
    String lastMessageId,
  ) async {
    String userId = auth.currentUser!.uid;
    await firestore.collection("chats").doc(getChatId(userId, peerId)).set({
      "type": "user", // "user" or "group"
      "last_message_id": lastMessageId,
      "user_id": userId,
      "r_user_id": peerId,
      "members": [
        userId,
        peerId,
      ],
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  static Future _updateChat(
    String peerId,
    String lastMessageId,
  ) async {
    String userId = auth.currentUser!.uid;
    await firestore.collection("chats").doc(getChatId(userId, peerId)).update({
      "last_message_id": lastMessageId,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  static Future _storeChatGroup(
    String groupId, {
    String? lastMessageId,
  }) async {
    await firestore.collection("chats").doc(groupId).update({
      "last_message_id": lastMessageId,
      "group_id": groupId,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  static Future _createChatGroup({
    required String displayName,
    required String imgUrl,
    required String groupId,
    required List<String> admins,
    required List<String> members,
  }) async {
    String userId = auth.currentUser!.uid;
    await firestore.collection("chats").doc(groupId).set({
      "id": groupId,
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

  static String getChatId(String userId, String peerId) {
    if (userId.hashCode <= peerId.hashCode) {
      return '$userId-$peerId';
    } else {
      return '$peerId-$userId';
    }
  }

  static Future signOutForGroup(String groupId) async {
    return firestore.collection("chats").doc(groupId).update({
      "admins": FieldValue.arrayRemove([auth.currentUser?.uid]),
      "members": FieldValue.arrayRemove([auth.currentUser?.uid]),
    });
  }

  static Future removeUserForGroup(String userId, String groupId) async {
    return firestore.collection("chats").doc(groupId).update({
      "admins": FieldValue.arrayRemove([userId]),
      "members": FieldValue.arrayRemove([userId]),
    });
  }

  static Future updateImgForGroup(String groupId, XFile? img) async {
    String? imgUrl = await AuthLogic.uploadImage(img!);

    await firestore.collection("chats").doc(groupId).update({
      "imgUrl": imgUrl,
    });
  }

  static Future updateDisplayNameForGroup(
      String groupId, String newDisplayName) async {
    await firestore.collection("chats").doc(groupId).update({
      "displayName": newDisplayName,
    });
  }
}
