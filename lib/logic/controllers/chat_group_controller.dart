import 'dart:async';
import 'dart:convert';

import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/logic/logic/home_logic_v3.dart';
import 'package:chatapp/logic/logic/logic.dart';
import 'package:chatapp/logic/models/group_model.dart';
import 'package:chatapp/logic/models/msg_group_model.dart';
import 'package:chatapp/logic/models/status_user_model.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class ChatGroupController extends GetxController {
  final AuthController authController = Get.find();
  List<UserModel> members = [];
  final GroupModel group = Get.arguments;
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final GetStorage _storage = GetStorage();
  StreamSubscription? _messageSubscription;
  bool isEmojiOpend = false;

  String _message = "";
  bool isLoading = false;
  bool isTyping = false;
  List<MsgGroup> messagesGroup = [];
  StatusUser status = StatusUser(status: false);
  XFile? image;

  String get message => _message;
  set message(String value) {
    _message = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getCashForMembers();
    initGetMessagesCaching();
    initChat();
  }

  void sendMessage() async {
    try {
      if (!group.members!.contains(authController.user?.uid)) {
        return;
      }
      // Check if there is a message or image to send
      if (message.isNotEmpty || image != null) {
        // Set loading state
        isLoading = true;
        update();

        // Build the message
        MsgGroup? msg = await _buildMessage();

        // // Start a new chat if messages are empty
        // if (messages.isEmpty) {
        //   await ChatLogic.startNewChat(authController.user!.uid, rUser.uid);
        // }
        await HomeLogicV3.updateChatGroup(group.id!, lastMessageId: msg!.id!);

        // Send the message and clear the text field
        await _sendMessageAndClearTextField(msg);

        // Send FCM notification
        await _sendFCMNotification(msg);
      }
    } catch (e) {
      // Handle any errors
      showErrorSnackbar("$e");
    } finally {
      // Reset loading state
      isLoading = false;
      update();
    }
  }

  Future<MsgGroup?> _buildMessage() async {
    String? imgUrl;
    if (image != null) {
      imgUrl = await ChatLogic.uploadImage(image!, group.id!);
      image = null;
      update();
    }

    return MsgGroup(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: authController.user!.uid,
      groupId: group.id,
      message: message,
      mediaType: "image",
      media: imgUrl,
    );
  }

  Future<void> _sendMessageAndClearTextField(MsgGroup msg) async {
    await ChatLogic.sendMessageForGroup(msg);
    textEditingController.clear();
    message = "";
    update();
  }

  Future<void> _sendFCMNotification(MsgGroup msg) async {
    await MyMethods.sendFCMMessage(
      title: authController.user!.email!.split("@").first,
      body: msg.message!,
      groupTokens: group.tokens,
      id: msg.userId.toString(),
      isGroup: true,
    );
  }

  void initGetMessagesCaching() {
    final data = _storage.read("G-${group.id}");
    if (data != null) {
      List<MsgGroup> msgs = (jsonDecode(data) as List)
          .map<MsgGroup>((e) => MsgGroup.fromJson(e, cc: true))
          .toList();
      messagesGroup.assignAll(msgs);
      update();
    }
  }

  void initChat() {
    // try {
    //   ChatLogic.getStatusStream(rUser.uid).listen((event) {
    //     status = event ?? StatusUser(status: false);
    //     update();
    //   }).onError((e) {
    //     showErrorSnackbar("$e");
    //   });
    // } catch (e) {
    //   showErrorSnackbar("${e}1");
    // }
    try {
      isLoading = true;
      update();
      _messageSubscription =
          ChatLogic.getMessagesForGroup(group.id!).listen((msgs) {
        isLoading = false;
        _updateMessages(ChatLogic.extractMessagesForGroup(msgs));
        if (msgs.docs.isNotEmpty) {
          cachingMessages(msgs);
        }
      });
    } catch (e) {
      showErrorSnackbar("${e}1");
    }
  }

  void _updateMessages(List<MsgGroup> msgs) {
    messagesGroup.assignAll(msgs);
    messagesGroup.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    update();
  }

  void cachingMessages(QuerySnapshot<Object?> msgs) {
    List dataList = msgs.docs
        .map(
          (e) =>
              MsgGroup.fromJson(e.data() as Map<String, dynamic>).toFullJson(),
        )
        .toList();
    _storage.write(
      "G-${group.id}",
      jsonEncode(dataList),
    );
  }

  void goTo() {
    final bottomOffset = scrollController.position.maxScrollExtent;
    scrollController.animateTo(
      bottomOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<UserModel?> getUserInCash(String uid) async {
    UserModel? user;
    if (members.where((u) => u.uid == uid).isNotEmpty) {
      return members.where((u) => u.uid == uid).first;
    }
    user = await ChatLogic.getUser(uid);
    if (user != null) {
      members.add(user);
      update();
      storeCashForMembers();
      return user;
    } else {
      return null;
    }
  }

  void getUser(String uid) async {
    UserModel? user = await ChatLogic.getUser(uid);
    if (user != null) {
      members.add(user);
      update();
      storeCashForMembers();
    }
  }

  void storeCashForMembers() {
    GetStorage box = GetStorage();
    box.write(
      "members-${group.id}",
      jsonEncode(members.map((e) => e.toJson()).toList()),
    );
  }

  void getCashForMembers() {
    GetStorage box = GetStorage();
    if (!box.hasData("members-${group.id}")) {
      return;
    }
    List<dynamic> membersG = jsonDecode(box.read("members-${group.id}"));
    members = membersG.map((e) {
      return UserModel.fromJson(e);
    }).toList();
  }

  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: MyMethods.bgColor,
      borderRadius: 10,
      colorText: Colors.white,
      borderColor: MyMethods.borderColor,
      borderWidth: 1,
    );
  }

  @override
  void onClose() {
    textEditingController.dispose();
    _messageSubscription?.cancel();
    super.onClose();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
    textEditingController.dispose();
  }
}
