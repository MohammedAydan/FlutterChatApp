import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/logic/controllers/chat_group_controller.dart';
import 'package:chatapp/logic/models/group_model.dart';
import 'package:chatapp/logic/models/msg_group_model.dart';
import 'package:chatapp/views/profiles/profile_group_screen.dart';
import 'package:chatapp/widgets/cached_image.dart';
import 'package:chatapp/widgets/chat_group_bottom_nav_bar.dart';
import 'package:chatapp/widgets/group_message_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatGroupScreen extends StatelessWidget {
  static const String routeName = '/ChatGroup';
  ChatGroupScreen({super.key});
  final ChatGroupController chatController = Get.put(ChatGroupController());
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final GroupModel? group = Get.arguments;
    if (group == null) {
      return const Center(
        child: Icon(
          Icons.forum_rounded,
          size: 200,
          color: MyMethods.borderColor,
        ),
      );
    }

    return GetBuilder(
      init: chatController,
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            backgroundColor: MyMethods.bgColor2,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              ProfileGroupScreen.routeName,
                              arguments: group,
                            );
                          },
                          child: (group.photoUrl != null)
                              ? CachedImage(
                                  imageUrl: group.photoUrl!,
                                  borderRadius: BorderRadius.circular(13),
                                )
                              : Text(group.displayName![0].toUpperCase()),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.displayName!,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            // Text(
                            //   controller.status.status!
                            //       ? "Online"
                            //       : "Offline ${controller.status.updatedAt != null ? ChatLogic.getFormattedDate(controller.status.updatedAt!) : ""}",
                            //   style: const TextStyle(
                            //     fontSize: 12,
                            //     color: MyMethods.colorText2,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        // Icon(Icons.call),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Icon(Icons.videocam),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Icon(Icons.more_vert),
                      ],
                    ),
                  ],
                ),
                if (controller.isLoading &&
                    controller.messagesGroup.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: LinearProgressIndicator(
                      minHeight: 2,
                      color: const Color.fromARGB(255, 49, 68, 97),
                      backgroundColor: MyMethods.bgColor2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ] else ...[
                  const SizedBox(),
                ],
              ],
            ),
          ),
          body: Builder(
            builder: (context) {
              if (controller.isLoading && controller.messagesGroup.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.messagesGroup.isEmpty && !controller.isLoading) {
                return Center(
                  child: Text("no_messages".tr),
                );
              }

              return Directionality(
                textDirection: TextDirection.ltr,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: controller.scrollController,
                  reverse: true,
                  itemCount: controller.messagesGroup.length,
                  itemBuilder: (context, index) {
                    MsgGroup msg = controller.messagesGroup[index];
                    bool isCurrentUserMessage =
                        msg.userId == authController.user!.uid;
                    return GroupMessageContainer(
                      group: group,
                      isCurrentUserMessage: isCurrentUserMessage,
                      msg: msg,
                    );
                  },
                ),
              );
            },
          ),
          bottomNavigationBar: ChatGroupBottomNavBar(controller: controller),
        );
      },
    );
  }
}
