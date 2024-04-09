import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/logic/controllers/home_controller.dart';
import 'package:chatapp/logic/models/group_model.dart';
import 'package:chatapp/views/chat/chat_group_screen.dart';
import 'package:chatapp/views/profiles/profile_group_screen.dart';
import 'package:chatapp/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupCard extends StatelessWidget {
  GroupCard({
    super.key,
    required this.groupData,
    required this.authController,
    this.lastMessage,
  });

  final GroupModel? groupData;
  final AuthController authController;
  final HomeController homeController = Get.find();
  final Widget? lastMessage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListTile(
        textColor: Colors.white,
        onTap: () {
          Get.toNamed(ChatGroupScreen.routeName, arguments: groupData);
        },
        title: Text("${groupData?.displayName}"),
        // title: Text("${groupData?.email!.split("@").first}"),
        subtitle: lastMessage,
        leading: GestureDetector(
          onTap: () {
            Get.toNamed(ProfileGroupScreen.routeName, arguments: groupData);
          },
          child: SizedBox(
            width: 45,
            height: 45,
            child: groupData != null
                ? groupData!.photoUrl != null
                    ? CachedImage(
                        imageUrl: groupData!.photoUrl!,
                        borderRadius: BorderRadius.circular(13),
                      )
                    : Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: MyMethods.bgColor2,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Text(groupData!.displayName![0].toUpperCase()),
                      )
                : Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: MyMethods.bgColor2,
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
