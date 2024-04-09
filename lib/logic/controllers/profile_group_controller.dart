import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/logic/home_logic_v3.dart';
import 'package:chatapp/logic/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileGroupController extends GetxController {
  final GroupModel group = Get.arguments;
  final TextEditingController displayNameForGroupEditController =
      TextEditingController();

  Future updateDisplayName() async {
    try {
      MyMethods.showLoadingDialog();
      await HomeLogicV3.updateDisplayNameForGroup(
        group.id!,
        displayNameForGroupEditController.text.trim(),
      );
      displayNameForGroupEditController.clear();
    } finally {
      Get.back();
      Get.back();
      Get.back();
    }
  }
}
