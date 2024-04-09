import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/logic/controllers/home_controller.dart';
import 'package:chatapp/logic/logic/home_logic_v3.dart';
import 'package:chatapp/logic/models/group_model.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:chatapp/views/chat/chat_screen.dart';
import 'package:chatapp/views/profiles/my_profile_screen.dart';
import 'package:chatapp/views/profiles/profile_screen.dart';
import 'package:chatapp/widgets/buttons/danger_button.dart';
import 'package:chatapp/widgets/buttons/outlined_button.dart';
import 'package:chatapp/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCard extends StatelessWidget {
  UserCard({
    super.key, // Use Key? instead of super.key
    required this.userData,
    required this.authController,
    this.lastMessage,
    this.isAdmin = false,
    this.my = false,
    this.isAdminControls = false,
    this.groupModel,
  }); // Initialize super with the key

  final UserModel? userData;
  final AuthController authController;
  final HomeController homeController = Get.find();
  final Widget? lastMessage;
  final bool isAdmin;
  final bool my;
  final bool isAdminControls;
  final GroupModel? groupModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (!my) {
          Get.toNamed(ChatScreen.routeName, arguments: userData);
        }
      },
      onLongPress: () {
        if (isAdminControls && !my) {
          Get.dialog(
            Dialog(
              elevation: 0,
              backgroundColor: MyMethods.bgColor,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("m_remove_u_1".tr),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: DangerButton(
                            width: double.infinity,
                            onPressed: () async {
                              try {
                                MyMethods.showLoadingDialog();
                                await HomeLogicV3.removeUserForGroup(
                                  userData!.uid,
                                  groupModel!.id!,
                                );
                              } catch (e) {
                                print(e);
                              } finally {
                                Get.back();
                                Get.back();
                                Get.back();
                              }
                            },
                            text: "remove".tr,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MyOutlinedButton(
                            width: double.infinity,
                            onPressed: () {
                              Get.back();
                            },
                            text: "cancel".tr,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
      trailing: isAdmin && my
          ? Text(
              "${"my".tr} - ${"admin".tr}",
              style: const TextStyle(color: MyMethods.blueColor2),
            )
          : isAdmin
              ? Text(
                  "admin".tr,
                  style: const TextStyle(color: MyMethods.blueColor2),
                )
              : my
                  ? Text(
                      "my".tr,
                      style: const TextStyle(color: MyMethods.blueColor2),
                    )
                  : null,
      title: Text(
        "${userData?.displayName}",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      subtitle: lastMessage,
      leading: GestureDetector(
        onTap: () {
          if (my) {
            Get.toNamed(MyProfileScreen.routeName, arguments: userData);
          } else {
            Get.toNamed(ProfileScreen.routeName, arguments: userData);
          }
        },
        child: SizedBox(
          // Wrap the leading widget with a Container
          width: 45, // Set a fixed width
          height: 45, // Set a fixed height
          child: userData == null
              ? const Center()
              : userData!.photoUrl != null
                  ? CachedImage(imageUrl: userData!.photoUrl!)
                  : Center(
                      child: Text(userData!.email![0].toUpperCase()),
                    ),
        ),
      ),
    );
  }
}
