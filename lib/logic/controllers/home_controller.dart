import 'dart:convert';

import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/logic/logic.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  List<UserModel> users = [];
  List<UserModel> searchUsersList = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    setupLifecycleListener();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    update();
  }

  void setCachingUsers(List<UserModel> users) {
    _box.write("friends", jsonEncode(users));
  }

  void setupLifecycleListener() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      SystemChannels.lifecycle.setMessageHandler((message) {
        if (message.toString().contains("inactive")) {
          ChatLogic.setStatus(user.uid, false);
        }
        if (message.toString().contains("resumed")) {
          ChatLogic.setStatus(user.uid, true);
        }
        return Future.value(message);
      });
    }
  }

  void searchUsers() async {
    if (searchController.text.isNotEmpty) {
      isSearching = true;
      update();
      try {
        searchUsersList = [
          await ChatLogic.searchUsers(
            searchController.text.trim(),
          )
        ];
        update();
      } catch (e) {
        if (e.toString().startsWith("Bad state:")) {
          showErrorSnackbar("Not found the user or a mistake in contacting");
        } else {
          showErrorSnackbar(e.toString());
        }
      } finally {
        isSearching = false;
        update();
      }
    }
  }

  void cleanSearch() {
    searchController.clear();
    searchUsersList.clear();
    isSearching = false;
    update();
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
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}
