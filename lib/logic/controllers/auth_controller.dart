import 'dart:convert';

import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/logic/auth_logic.dart';
import 'package:chatapp/logic/logic/logic.dart';
import 'package:chatapp/logic/models/group_model.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:chatapp/views/auth/signin_screen.dart';
import 'package:chatapp/views/chat/chat_group_screen.dart';
import 'package:chatapp/views/chat/chat_screen.dart';
import 'package:chatapp/views/home/home_screen.dart';
import 'package:chatapp/views/v_w/new_version.dart';
import 'package:chatapp/views/v_w/not_works_app.dart';
import 'package:chatapp/views/v_w/not_works_version.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  bool isLoading = false;
  TextEditingController displayNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController displayNameEditController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  String error = "";
  XFile? img;

  void setLoading(bool loading) {
    isLoading = loading;
    update();
  }

  void register() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'error'.tr,
        'a_f_r'.tr,
        colorText: Colors.white,
        backgroundColor: MyMethods.bgColor2,
      );
      return;
    }

    if (img == null) {
      Get.snackbar(
        'error'.tr,
        'p_s_i'.tr,
        colorText: Colors.white,
        backgroundColor: MyMethods.bgColor2,
      );
      return;
    }

    try {
      error = "";
      update();
      setLoading(true);
      UserCredential res = await AuthLogic.register(
        displayNameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        img!,
      );
      user = res.user;
      update();
      Get.offAllNamed(HomeScreen.routeName);
      MyMethods.storeFCMData(user!.uid);
    } on FirebaseAuthException catch (e) {
      error = "e_o".tr;
      update();
      Get.snackbar('error'.tr, "e_o".tr);
    } finally {
      setLoading(false);
    }
  }

  void signin() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'error'.tr,
        'p_e_e_a_p'.tr,
        colorText: Colors.white,
        backgroundColor: MyMethods.bgColor2,
      );
      return;
    }

    try {
      error = "";
      update();
      setLoading(true);
      UserCredential res = await AuthLogic.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      user = res.user;
      update();
      Get.offAllNamed(HomeScreen.routeName);
      MyMethods.storeFCMData(user!.uid);
    } on FirebaseAuthException catch (e) {
      error = "e_e_a_p".tr;
      update();
      Get.snackbar('error'.tr, "e_e_a_p".tr);
    } finally {
      setLoading(false);
    }
  }

  void signInWithGoogle() async {
    try {
      error = "";
      update();
      setLoading(true);
      UserCredential res = await AuthLogic.signInWithGoogle();
      user = res.user;
      update();
      Get.offAllNamed(HomeScreen.routeName);
      MyMethods.storeFCMData(user!.uid);
    } on FirebaseAuthException catch (e) {
      error = "e_login".tr;
      update();
      Get.snackbar('error'.tr, "e_login".tr);
    } finally {
      setLoading(false);
    }
  }

  void updateProfile() async {
    MyMethods.showLoadingDialog();
    try {
      if (displayNameEditController.text.trim().isNotEmpty) {
        user = await AuthLogic.updateUser(
          displayName: displayNameEditController.text.trim(),
        );
      }
      update();
    } catch (e) {
      Get.snackbar('error'.tr, "e_o".tr);
    } finally {
      Get.back();
      Get.back();
    }
  }

  void updateProfileImage(ImageSource source) async {
    MyMethods.showLoadingDialog();
    try {
      ImagePicker picker = ImagePicker();
      img = await picker.pickImage(source: source);
      if (img != null) {
        user = await AuthLogic.updateUserImage(fileImg: img!);
        update();
      }
    } catch (e) {
      Get.snackbar('error'.tr, "e_o".tr);
    } finally {
      Get.back();
    }
  }

  void signout() async {
    try {
      setLoading(true);
      MyMethods.destroyFCMDviceData(user!.uid);
      await AuthLogic.signOut();
      error = "";
      update();
      Get.offAllNamed(SigninScreen.routeName);
      ChatLogic.setStatus(user!.uid, false);
    } catch (e) {
      Get.snackbar('error'.tr, "e_o".tr);
    } finally {
      setLoading(false);
    }
  }

  void fcmListener() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data['type'] == "chat" && message.data['id'] != null) {
        try {
          MyMethods.showLoadingDialog();
          if (message.data['chat_type'] == null ||
              message.data['chat_type'] == "user") {
            UserModel? user = await ChatLogic.getUser(message.data['id']);
            if (user != null) {
              Get.toNamed(ChatScreen.routeName, arguments: user);
            } else {
              print('User not found');
            }
          } else if (message.data['chat_type'] == "group") {
            GroupModel? group = await ChatLogic.getGroup(message.data['id']);
            if (group != null) {
              Get.toNamed(ChatGroupScreen.routeName, arguments: group);
            } else {
              print('Group not found');
            }
          }
        } catch (error) {
          print('Error fetching data: $error');
        } finally {
          Get.back();
        }
      }
    });
  }

  void start() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 1),
        ),
      );
      await remoteConfig.fetchAndActivate();

      Map<String, dynamic> versionData =
          jsonDecode(remoteConfig.getString("version"));
      bool worksApp = remoteConfig.getBool("worksApp");
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;

      if (worksApp == false) {
        Get.offAll(() => const NotWorksApp());
        return;
      }

      if ((versionData['version'].toString().compareTo(version) == 1) &&
          versionData['works'] == false) {
        Get.offAll(() => const NotWorksVersion());
        return;
      }

      if (FirebaseAuth.instance.currentUser != null) {
        user = FirebaseAuth.instance.currentUser;
        MyMethods.storeFCMData(user!.uid);
        update();
        Get.offAllNamed(HomeScreen.routeName);
        ChatLogic.setStatus(user!.uid, true);
        fcmListener();
      } else {
        Get.offAllNamed(SigninScreen.routeName);
      }

      if ((versionData['version'].toString().compareTo(version) == 1)) {
        newVersion(versionData['version'].toString());
      }
    } catch (e) {
      if (FirebaseAuth.instance.currentUser != null) {
        user = FirebaseAuth.instance.currentUser;
        MyMethods.storeFCMData(user!.uid);
        update();
        Get.offAllNamed(HomeScreen.routeName);
        ChatLogic.setStatus(user!.uid, true);
        fcmListener();
      } else {
        Get.offAllNamed(SigninScreen.routeName);
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    start();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
