import 'dart:async';
import 'dart:convert';

import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/logic/logic/home_logic.dart';
import 'package:chatapp/logic/logic/home_logic_v2.dart';
import 'package:chatapp/logic/logic/home_logic_v3.dart';
import 'package:chatapp/logic/logic/logic.dart';
import 'package:chatapp/logic/models/msg_group_model.dart';
import 'package:chatapp/logic/models/msg_model.dart';
import 'package:chatapp/logic/models/status_user_model.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  final AuthController _authController = Get.find();
  final UserModel rUser = Get.arguments;
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final GetStorage _storage = GetStorage();
  StreamSubscription? _messageSubscription;
  bool isEmojiOpend = false;

  String _message = "";
  bool isLoading = false;
  bool isTyping = false;
  List<Msg> messages = [];
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
    initGetMessagesCaching();
    initChat();
  }

  void sendMessage() async {
    try {
      // Check if there is a message or image to send
      if (message.isNotEmpty || image != null) {
        // Set loading state
        isLoading = true;
        update();

        // Build the message
        Msg? msg = await _buildMessage();

        // // Start a new chat if messages are empty
        // if (messages.isEmpty) {
        //   await ChatLogic.startNewChat(_authController.user!.uid, rUser.uid);
        // }

        if (messages.isEmpty) {
          await HomeLogicV3.storeChat(rUser.uid, msg!.id!);
        } else {
          await HomeLogicV3.updateChat(rUser.uid, msg!.id!);
        }

        // Send the message and clear the text field
        await _sendMessageAndClearTextField(msg);

        // Send FCM notification
        await _sendFCMNotification(msg);
      }
    } catch (e) {
      // Handle any errors
      print(e);
      showErrorSnackbar("$e");
    } finally {
      // Reset loading state
      isLoading = false;
      update();
    }
  }

  Future<Msg?> _buildMessage() async {
    String? imgUrl;
    if (image != null) {
      imgUrl = await ChatLogic.uploadImage(image!, rUser.uid);
      image = null;
      update();
    }

    return Msg(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: _authController.user!.uid,
      rUserId: rUser.uid,
      message: message,
      mediaType: "image",
      media: imgUrl,
    );
  }

  Future<void> _sendMessageAndClearTextField(Msg msg) async {
    await ChatLogic.sendMessage(msg);
    textEditingController.clear();
    message = "";
    update();
  }

  Future<void> _sendFCMNotification(Msg msg) async {
    await MyMethods.sendFCMMessage(
      title: _authController.user!.email!.split("@").first,
      body: msg.message!,
      user: rUser,
      id: msg.userId.toString(),
    );
  }

  void initGetMessagesCaching() {
    final data = _storage.read("${_authController.user?.uid}-${rUser.uid}");
    if (data != null) {
      List<Msg> msgs = (jsonDecode(data) as List)
          .map<Msg>((e) => Msg.fromJson(e, cc: true))
          .toList();
      messages.assignAll(msgs);
      update();
    }
  }

  void initChat() {
    try {
      ChatLogic.getStatusStream(rUser.uid).listen((event) {
        status = event ?? StatusUser(status: false);
        update();
      }).onError((e) {
        showErrorSnackbar("$e");
      });
    } catch (e) {
      showErrorSnackbar("${e}1");
    }
    try {
      isLoading = true;
      update();
      _messageSubscription = ChatLogic.getMessages(
        _authController.user!.uid,
        rUser.uid,
      ).listen((msgs) {
        isLoading = false;
        _updateMessages(ChatLogic.extractMessages(msgs));
        if (msgs.docs.isNotEmpty) {
          cachingMessages(msgs);
        }
      });
    } catch (e) {
      showErrorSnackbar("${e}1");
    }
  }

  void _updateMessages(List<Msg> msgs) {
    messages.assignAll(msgs);
    messages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    update();
  }

  void cachingMessages(QuerySnapshot<Object?> msgs) {
    List dataList = msgs.docs
        .map(
          (e) => Msg.fromJson(e.data() as Map<String, dynamic>).toFullJson(),
        )
        .toList();
    _storage.write(
      "${_authController.user?.uid}-${rUser.uid}",
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
  }
}
