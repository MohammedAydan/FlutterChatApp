import 'dart:convert';

import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/logic/logic/home_logic_v3.dart';
import 'package:chatapp/logic/logic/logic.dart';
import 'package:chatapp/logic/models/chat_model.dart';
import 'package:chatapp/logic/models/chat_model_f.dart';
import 'package:chatapp/logic/models/group_model.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ChatsController extends GetxController {
  AuthController authController = Get.find();
  List<ChatModelF> chatModels = [];
  bool isLoading = false;

  void storeCashChats(List<ChatModelF?> chats) {
    GetStorage box = GetStorage();
    final encodeData = jsonEncode(chats.map((e) => e?.toJson()).toList());
    box.write("chats", encodeData);
  }

  void initializationForChats() {
    GetStorage box = GetStorage();
    if (!box.hasData("chats")) {
      return;
    }

    List<dynamic> chatsMap = jsonDecode(box.read("chats"));
    chatModels = chatsMap.map<ChatModelF>((e) {
      return ChatModelF.convertChatModelToChatModelF(
        id: e["id"],
        type: e['type'] ?? "user",
        lastMessageId: e['last_message_id'],
        user: e['user'] != null ? UserModel.fromJson(e['user']) : null,
        group: e['group'] != null ? GroupModel.fromJson(e['group']) : null,
        createdAt:
            e['created_at'] != null ? DateTime.parse(e['created_at']) : null,
      );
    }).toList();
    update();
  }

  void getChats() {
    try {
      isLoading = true;
      update(); // Trigger UI update

      HomeLogicV3.getChats().listen((event) async {
        List<ChatModel> chats =
            event.docs.map((e) => ChatModel.fromJson(e.id, e.data())).toList();
        print("Number of chats received: ${chats.length}");

        List<Future<ChatModelF>> chatFutures = chats.map((chatModel) async {
          String? userId = chatModel.members!.first;
          String? rUserId = chatModel.members!.last;
          if (authController.user?.uid == userId) {
            userId = rUserId; // If userId is null, fallback to rUserId
          } else {
            userId = userId; // If userId is null, fallback to itself
          }

          if (chatModel.type == "user" || chatModel.type == null) {
            print("User Chat");
            UserModel? user = await ChatLogic.getUser(userId);
            return ChatModelF.convertChatModelToChatModelF(
              id: rUserId,
              lastMessageId: chatModel.lastMessageId,
              user: user,
              createdAt: chatModel.createdAt,
              type: "user",
            );
          } else {
            print("Group Chat");
            GroupModel? group = await ChatLogic.getGroup(chatModel.id!);
            print(".............................G.DATA.....");
            return ChatModelF.convertChatModelToChatModelF(
              id: chatModel.id,
              lastMessageId: chatModel.lastMessageId,
              group: group,
              createdAt: chatModel.createdAt,
              type: "group",
            );
          }
        }).toList();

        Future.wait(chatFutures).then((cs) {
          print("..........................................................2");
          print("..........................................................1");
          print(cs.length);
          // chatModels.clear();
          // manageChats(chatModels);
          if (chatModels.map((e) => e.toJson()).toString() !=
              cs.map((e) => e.toJson()).toString()) {
            chatModels = cs;
          }

          // Sort the chat models by createdAt field in descending order
          chatModels.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

          // Store updated chats locally
          storeCashChats(chatModels);

          isLoading = false;
          update(); // Trigger UI update
        }).catchError((error) {
          // Handle errors if any
          print("Error: $error");
          isLoading = false;
          update(); // Trigger UI update
        });
      }, onError: (error) {
        // Handle stream errors
        print("Stream error: $error");
        isLoading = false;
        update(); // Trigger UI update
      });
    } catch (e) {
      // Catch any unexpected errors
      print("Error: $e");
      isLoading = false;
      update(); // Trigger UI update
      showErrorSnackbar(e.toString());
    }
  }

  void manageChats(List<ChatModelF> chats) {
    if (chats.isNotEmpty) {
      // Iterate through the new chat models
      for (var newChat in chats) {
        // Check if the current new chat model already exists in the list
        var existingChatIndex =
            chatModels.indexWhere((chat) => chat.id == newChat.id);

        if (existingChatIndex != -1) {
          // If it exists, update the existing chat model
          chatModels.removeWhere((e) => e.id == newChat.id);
          chatModels = {...chatModels, newChat}.toSet().toList();
        } else {
          // If the chat model doesn't exist, add it to the list of new chat models
          chatModels.add(newChat);
        }
      }

      // Sort the chat models by createdAt field in descending order
      chatModels.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      // Store updated chats locally
      storeCashChats(chatModels);
    }
  }

  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      colorText: Colors.white,
      backgroundColor: MyMethods.bgColor2,
    );
  }

  @override
  void onInit() {
    super.onInit();
    initializationForChats();
    getChats();
  }
}
