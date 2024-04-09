import 'dart:async';
import 'dart:io';

import 'package:chatapp/logic/models/group_model.dart';
import 'package:chatapp/logic/models/msg_group_model.dart';
import 'package:chatapp/logic/models/msg_model.dart';
import 'package:chatapp/logic/models/status_user_model.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class ChatLogic {
  static User? user = FirebaseAuth.instance.currentUser;
  static CollectionReference usersDb =
      FirebaseFirestore.instance.collection("users");
  // static CollectionReference groupsDb =
  //     FirebaseFirestore.instance.collection("users");
  static CollectionReference statusUserDb =
      FirebaseFirestore.instance.collection("status");
  static CollectionReference chatsDb =
      FirebaseFirestore.instance.collection("chats");

  static String getChatId(String userId, String peerId) {
    if (userId.hashCode <= peerId.hashCode) {
      return '$userId-$peerId';
    } else {
      return '$peerId-$userId';
    }
  }

  static Future<UserModel?> getUser(String uid) async {
    GetStorage box = GetStorage();

    // // check has user
    // if (box.hasData(uid)) {
    //   // Attempt to retrieve cached user data
    //   dynamic cachedUserData = box.read(uid);

    //   // If cached data exists, return it immediately
    //   if (cachedUserData != null) {
    //     UserModel userCash = UserModel.fromJson(cachedUserData);
    //     print("USER CASHING");
    //     return userCash;
    //   }
    // }

    // If there's no cached data, fetch data from the database
    final res = await usersDb.doc(uid).get();
    List<String> tokens = await getTokensByUserId(uid);
    final UserModel user = UserModel.fromJson(
      res.data() as Map<String, dynamic>,
      tokens: tokens,
    );

    // Write fetched data to cache
    box.write(uid, user.toJson());

    // Return fetched user data
    return user;
  }

  static Future<UserModel?> getUserInCash(String uid) async {
    GetStorage box = GetStorage();

    // check has user
    if (box.hasData(uid)) {
      // Attempt to retrieve cached user data
      dynamic cachedUserData = box.read(uid);

      // If cached data exists, return it immediately
      if (cachedUserData != null) {
        UserModel userCash = UserModel.fromJson(cachedUserData);
        return userCash;
      }
    }

    // If there's no cached data, fetch data from the database
    final res = await usersDb.doc(uid).get();
    List<String> tokens = await getTokensByUserId(uid);
    final UserModel user = UserModel.fromJson(
      res.data() as Map<String, dynamic>,
      tokens: tokens,
    );

    // Write fetched data to cache
    box.write(uid, user.toJson());

    // Return fetched user data
    return user;
  }

  static Future<GroupModel?> getGroup(String id) async {
    print("Start........................................");
    final res = await chatsDb.doc(id).get();
    if (!res.exists) {
      // Handle the case where the document doesn't exist
      return null; // Or throw an error, depending on your application logic
    }

    Map<String, dynamic>? data = res.data() as Map<String, dynamic>;
    if (!data.containsKey('members')) {
      // Handle the case where the 'members' field doesn't exist
      return null; // Or throw an error, depending on your application logic
    }

    print(data);

    List members = data['members'];

    // Use Future.wait to fetch tokens concurrently
    List<Future<List<String>>> tokenFutures = members.map((member) async {
      List<String> token = (await getTokensByUserId(member));
      return token;
    }).toList();

    List<String> tokens = [];
    List<List<String>> tokens_ = await Future.wait(tokenFutures);
    for (List<String> tokensByU in tokens_) {
      List<String> ts = tokensByU.map((e) => e).toList();
      tokens.addAll(ts);
    }

    print("Start........................................end");
    print(data);
    print(tokens);

    return GroupModel.fromJson(
      data, // Pass all data to GroupModel.fromJson
      tokens: tokens,
    );
  }

  static Future<List<String>> getTokensByUserId(String id) async {
    try {
      final QuerySnapshot res = await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .collection("devices")
          .get();
      return res.docs
          .map(
              (e) => (e.data() as Map<String, dynamic>)['fcm_token'].toString())
          .toList();
    } catch (e) {
      print("Error getting tokens by user ID: $e");
      return []; // Return an empty list if an error occurs
    }
  }

  static Stream<UserModel?> getUserAndGetLastMessageStream(String uid) {
    final controller = StreamController<UserModel?>();

    Future<void> fetchData() async {
      try {
        final resUser = await usersDb.doc(uid).get();

        Stream<QuerySnapshot<Map<String, dynamic>>> messageStream = chatsDb
            .doc(getChatId(user!.uid, uid))
            .collection("messages")
            .orderBy("created_at", descending: true)
            .limit(1)
            .snapshots();

        await for (var snapshot in messageStream) {
          if (snapshot.docs.isNotEmpty) {
            controller.add(UserModel.fromJson(
              resUser.data() as Map<String, dynamic>,
              lastMessage: Msg.fromJson(snapshot.docs.first.data()),
            ));
          } else {
            controller.add(
                UserModel.fromJson(resUser.data() as Map<String, dynamic>));
          }
          break; // We only need the latest message
        }
      } catch (e) {
        // Error occurred, handle it accordingly
        print("Error fetching user or last message: $e");
        controller.add(null);
      } finally {
        controller.close();
      }
    }

    fetchData();

    return controller.stream;
  }

  static Stream<QuerySnapshot<Object?>> getUsers() {
    // chats -> "getChatId(msg.userId!, msg.rUserId!)" -> messages -> messages data
    if (user == null) return const Stream.empty();
    chatsDb.doc().snapshots().listen((event) {});
    return usersDb.where("uid", isNotEqualTo: user!.uid).snapshots();
  }

  static Stream<DocumentSnapshot<Object?>> getStatusUser(String id) {
    return statusUserDb.doc(id).snapshots();
  }

  static Future<String?> uploadImage(XFile file, String uid) async {
    String nameOnly = file.name.split('.').first;
    String entension = file.name.split('.').last;
    String filePath = '$nameOnly-$uid.$entension';

    FirebaseStorage firestore = FirebaseStorage.instance;
    final ref = firestore.ref().child("chat/images/$filePath");
    await ref.putFile(File(file.path));
    return await ref.getDownloadURL();
  }

  static Future<void> sendMessage(Msg msg) async {
    await chatsDb
        .doc(getChatId(msg.userId!, msg.rUserId!))
        .collection("messages")
        .doc(msg.id)
        .set(msg.toJson());
  }

  static Future<void> sendMessageForGroup(MsgGroup msg) async {
    await chatsDb
        .doc(msg.groupId)
        .collection("messages")
        .doc(msg.id)
        .set(msg.toJson());
  }

  static List<Msg> extractMessages(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => Msg.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static List<MsgGroup> extractMessagesForGroup(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => MsgGroup.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static Stream<QuerySnapshot<Object?>> getMessages(
    String userId,
    String rUserId,
  ) {
    return chatsDb
        .doc(getChatId(userId, rUserId))
        .collection("messages")
        .orderBy('created_at', descending: true)
        .limit(40)
        .snapshots();
  }

  static Stream<QuerySnapshot<Object?>> getMessagesForGroup(
    String groupId,
  ) {
    return chatsDb
        .doc(groupId)
        .collection("messages")
        .orderBy('created_at', descending: true)
        .limit(60)
        .snapshots();
  }

  static Future updateReadMessage(Msg msg) async {
    await chatsDb
        .doc(getChatId(msg.userId!, msg.rUserId!))
        .collection("messages")
        .doc(msg.id)
        .update({
      "read_at": DateTime.now(),
    });
  }

  static Future updateReadMessageForGroup(MsgGroup msg, String groupId) async {
    await chatsDb.doc(groupId).collection("messages").doc(msg.id).update({
      "read_at": FieldValue.arrayUnion([
        user?.uid,
      ]),
    });
  }

  static String getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    // Formatting date
    if (diff.inDays > 0) {
      return DateFormat('dd/MM/yyyy hh:mm a').format(date);
      // return DateFormat('dd/MM/yyyy').format(date);
    }
    // Formatting time
    else {
      return DateFormat('hh:mm a').format(date);
    }
  }

  static Future<void> deleteMessage(Msg msg) async {
    await chatsDb
        .doc(getChatId(msg.userId!, msg.rUserId!))
        .collection("messages")
        .doc(msg.id)
        .delete();
  }

  static Future<void> deleteChat(String userId, String rUserId) async {
    await chatsDb.doc(getChatId(userId, rUserId)).delete();
  }

  static Future<void> deleteAllMessages(String userId, String rUserId) async {
    final chatId = getChatId(userId, rUserId);
    final messages = await chatsDb.doc(chatId).collection("messages").get();
    for (final message in messages.docs) {
      await message.reference.delete();
    }
  }

  static Future<void> deleteAllChats(int userId) async {
    final chats = await chatsDb.get();
    for (final chat in chats.docs) {
      if (chat.id.contains(userId.toString())) {
        await chat.reference.delete();
      }
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
    String userId,
    String rUserId,
  ) {
    return chatsDb
        .doc(getChatId(userId, rUserId))
        .collection("messages")
        .orderBy("created_at", descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> setStatus(String userId, bool status) async {
    await statusUserDb.doc(userId).set({
      'user_id': userId,
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  static Stream<StatusUser?> getStatusStream(String userId) {
    return statusUserDb.doc(userId).snapshots().map((statusSnapshot) {
      if (statusSnapshot.exists) {
        final data = statusSnapshot.data() as Map<String, dynamic>;
        return StatusUser.fromJson(data);
      } else {
        return null;
      }
    });
  }

  // testing
  static Future startNewChat(String myId, String rUserId) async {
    await usersDb
        .doc(myId)
        .collection("chats")
        .doc(getChatId(myId, rUserId))
        .set({
      "chat_id": getChatId(myId, rUserId),
      "r_user_id": rUserId,
      "created_at": DateTime.now().toIso8601String(),
    });
    await usersDb
        .doc(rUserId)
        .collection("chats")
        .doc(getChatId(rUserId, myId))
        .set({
      "chat_id": getChatId(rUserId, myId),
      "r_user_id": myId,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  static Stream<QuerySnapshot<Object?>> getFriends(String myId) {
    return usersDb
        .doc(myId)
        .collection("chats")
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  static Future<void> deleteChatFriend(String userId, String rUserId) async {
    await usersDb
        .doc(userId)
        .collection("chats")
        .doc(getChatId(userId, rUserId))
        .delete();
  }

  static Future searchUsers(String email) async {
    final res = await usersDb
        .where("email", isEqualTo: email)
        .where("email", isNotEqualTo: user?.email)
        .get();
    List<String> tokens = await getTokensByUserId(res.docs.first.id);
    return UserModel.fromJson(
      res.docs.first.data() as Map<String, dynamic>,
      tokens: tokens,
    );
  }
}
