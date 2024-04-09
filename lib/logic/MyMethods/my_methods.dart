import 'dart:io';

import 'package:chatapp/logic/logic/logic.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyMethods {
  static const Color bgColor = Color(0xff0f172a);
  static const Color bgColor2 = Color(0xff1e293b);
  static const Color borderColor = Color(0xff1e293b);
  static const Color inputColor = Color(0xff1e293b);
  static const Color colorText1 = Color(0xffffffff);
  static const Color colorText2 = Color(0xff9ca3af);
  static const Color blueColor1 = Color(0xff2563eb);
  static const Color blueColor2 = Color(0xff3b82f6);

  static Color bgColorL = const Color(0xfff0f4f8);
  static Color bgColor2L = const Color(0xffe5e9f2);
  static Color borderColorL = const Color(0xffd7dbe4);
  static Color inputColorL = const Color(0xffd7dbe4);
  static Color colorText1L = const Color(0xff000000);
  static Color colorText2L = const Color(0xff495057);
  static Color blueColor1L = const Color(0xff007bff);
  static Color blueColor2L = const Color(0xff6cb2eb);

  static void storeFCMData(String userId) async {
    if (kIsWeb) {
      return;
    }
    FirebaseMessaging fcm = FirebaseMessaging.instance;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("devices")
        .doc("${Platform.operatingSystem}-${Platform.operatingSystemVersion}")
        .set({
      "user_id": userId,
      "fcm_token": await fcm.getToken(),
      "device_os": Platform.operatingSystem,
      "device_os_version": Platform.operatingSystemVersion,
      "created_at": FieldValue.serverTimestamp(),
      "updated_at": FieldValue.serverTimestamp(),
    });
  }

  static void destroyFCMDviceData(String userId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("devices")
        .doc("${Platform.operatingSystem}-${Platform.operatingSystemVersion}")
        .delete();
  }

  static Future<void> sendFCMMessage({
    required String title,
    required String body,
    String? topic,
    String? token,
    List<String>? groupTokens,
    UserModel? user,
    String? id,
    bool isGroup = false,
  }) async {
    String server = "https://fcm.googleapis.com/fcm/send";
    String senderId = "419151198841"; // Project ID of FCM project
    String serverKey =
        "AAAAYZdbunk:APA91bFv8FQY5IDppD8lDzoiPTZVqOZovaWJLC61NMiEyLNrO8eskBteRlLa-uOJ_AjFHeL-yFlIt-VKHvYEchixDK2QN6bc61iCu11r3QK85p0hVFbS9i75uJzrBMnWU9tMNBIyEA-p";

    print("...............Start send notification.........");

    List<String> tokens = [];
    if (groupTokens != null && groupTokens.isNotEmpty) {
      tokens.addAll(groupTokens);
    } else if (user != null && user.tokens != null) {
      tokens.addAll(user.tokens!);
    } else if (user != null) {
      print("...............Get user tokens.................");
      try {
        final res = await ChatLogic.getTokensByUserId(user.uid);
        tokens.addAll(res.toList());
      } catch (e) {
        print("Error getting user tokens: $e");
        return; // Return here to avoid further execution if token retrieval fails
      }
    }
    print("...............send notification.........");
    print(tokens);

    if (tokens.isNotEmpty || token != null || topic != null) {
      Dio dio = Dio();
      Map<String, dynamic> requestData = {
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "sound": "default",
          "status": "done",
          "message": "Text Message",
          "type": "chat",
          "chat_type": isGroup ? "group" : "user",
          "id": id,
        },
      };

      if (topic != null) {
        requestData["to"] = "/topics/$topic";
      } else if (token != null) {
        requestData["to"] = token;
      } else if (tokens.isNotEmpty) {
        requestData["registration_ids"] = tokens;
      }

      try {
        await dio.post(
          server,
          data: requestData,
          options: Options(
            headers: {
              Headers.contentTypeHeader: Headers.jsonContentType,
              "Authorization": "key=$serverKey",
              "project_id": senderId,
            },
          ),
        );
        print("Successful send notification");
      } catch (e) {
        print("Error sending notification: $e");
        rethrow;
      }
    }
  }

  static showLoadingDialog() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }
}
