import 'package:chatapp/Widgets/chat_bottom_nav_bar.dart';
import 'package:chatapp/Widgets/message_container.dart';
import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/logic/controllers/chat_controller.dart';
import 'package:chatapp/logic/logic/logic.dart';
import 'package:chatapp/logic/models/msg_model.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:chatapp/views/profiles/profile_screen.dart';
import 'package:chatapp/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/Chat';
  ChatScreen({super.key});
  final ChatController chatController = Get.put(ChatController());
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Get.arguments;
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
                              ProfileScreen.routeName,
                              arguments: user,
                            );
                          },
                          child: (user != null && user.photoUrl != null)
                              ? CachedImage(imageUrl: user.photoUrl!)
                              : Text(user!.email![0].toUpperCase()),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${user.displayName}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              controller.status.status!
                                  ? "online".tr
                                  : "${"offline".tr} ${controller.status.updatedAt != null ? ChatLogic.getFormattedDate(controller.status.updatedAt!) : ""}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: MyMethods.colorText2,
                              ),
                            ),
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
                if (controller.isLoading && controller.messages.isNotEmpty) ...[
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
              if (controller.isLoading && controller.messages.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.messages.isEmpty && !controller.isLoading) {
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
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    Msg msg = controller.messages[index];
                    bool isCurrentUserMessage =
                        msg.userId == authController.user!.uid;
                    return MessageContainer(
                      isCurrentUserMessage: isCurrentUserMessage,
                      msg: msg,
                    );
                  },
                ),
              );
            },
          ),
          bottomNavigationBar: ChatBottomNavBar(controller: controller),
        );
      },
    );
  }
}
