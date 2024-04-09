import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/logic/logic/auth_logic.dart';
import 'package:chatapp/logic/logic/home_logic.dart';
import 'package:chatapp/logic/logic/home_logic_v2.dart';
import 'package:chatapp/logic/logic/logic.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupController extends GetxController {
  bool isLoading = false;
  AuthController authController = Get.find();
  TextEditingController nameGroupEditingController = TextEditingController();
  XFile? img;
  List<UserModel> selectedUsers = [];
  List<UserModel> selectedAdmins = [];

  bool isSelected(UserModel user) {
    return selectedUsers.contains(user);
  }

  bool isSelectedAdmin(UserModel user) {
    return selectedAdmins.contains(user);
  }

  void selectOrUnselect(UserModel user) {
    if (isSelected(user)) {
      selectedUsers.remove(user);
      selectedAdmins.remove(user);
    } else {
      selectedUsers.add(user);
    }
    update();
  }

  void selectOrUnselectAdmin(UserModel user) {
    if (isSelectedAdmin(user)) {
      selectedAdmins.remove(user);
    } else {
      if(!isSelected(user)){
        selectedUsers.add(user);
      }
      selectedAdmins.add(user);
    }
    update();
  }

  void unselectAll() {
    selectedUsers.clear();
    selectedAdmins.clear();
    update();
  }

  void unselectAllAdmins() {
    selectedAdmins.clear();
    update();
  }

  void createGroup() async {
    isLoading = true;
    update();
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    String d1 = DateTime.now().microsecondsSinceEpoch.toString();
    String d2 = DateTime.now().microsecondsSinceEpoch.toString();
    String id = "G-$d1-${authController.user?.uid}-$d2";
    try {
      List<String> admins = selectedAdmins.map((e) => e.uid).toList();
      List<String> members = selectedUsers.map((e) => e.uid).toList();
      admins.add(authController.user!.uid);
      members.add(authController.user!.uid);
      String? imgUrl = await AuthLogic.uploadImage(img!);
      await HomeLogicV2.createChatGroup(
        displayName: nameGroupEditingController.text,
        imgUrl: imgUrl ?? "",
        groupId: id,
        admins: admins,
        members: members,
      );
    } catch (e) {
      showErrorSnackbar(e.toString());
      print(e);
    } finally {
      isLoading = false;
      update();
      Get.back();
      Get.back();
      Get.back();
    }
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
}
