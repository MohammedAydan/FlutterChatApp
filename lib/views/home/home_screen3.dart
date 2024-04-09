import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/logic/controllers/chats_controller.dart';
import 'package:chatapp/logic/models/chat_model_f.dart';
import 'package:chatapp/views/ai/gemini_chat_screen.dart';
import 'package:chatapp/views/new_chat_screen.dart';
import 'package:chatapp/views/privacy/privacy_screen.dart';
import 'package:chatapp/views/profiles/my_profile_screen.dart';
import 'package:chatapp/widgets/cached_image.dart';
import 'package:chatapp/widgets/get_last_message_group.dart';
import 'package:chatapp/widgets/group_card.dart';
import 'package:chatapp/widgets/lang_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../widgets/get_last_message.dart';
import '../../widgets/user_card.dart';

class HomeScreen3 extends StatelessWidget {
  static const String routeName = "/home2";
  HomeScreen3({super.key});
  final AuthController authController = Get.find();
  final ChatsController chatsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 20),
          // ClipOval(
          //   child: Image.asset(
          //     "assets/images/chat-logo.png",
          //     width: 50,
          //     height: 50,
          //   ),
          // ),
          // const Text(
          //   "Home",
          //   style: TextStyle(
          //     color: MyMethods.colorText1,
          //     fontSize: 25,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    "assets/images/chat-logo.png",
                    width: 47,
                    height: 47,
                  ),
                ),
                const Text(
                  "CHATAPP",
                  style: TextStyle(
                    color: MyMethods.colorText1,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PopupMenuButton(
                  position: PopupMenuPosition.under,
                  color: MyMethods.bgColor2,
                  elevation: 0,
                  popUpAnimationStyle: AnimationStyle(
                    curve: Curves.decelerate,
                    reverseCurve: Curves.decelerate,
                  ),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1,
                      color: MyMethods.bgColor,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        onTap: () {
                          Get.toNamed(MyProfileScreen.routeName);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.account_circle,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "profile".tr,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          const LangButton().changeLang();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.language_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              Get.locale?.languageCode == "en" ? "AR" : "EN",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      // Test
                      PopupMenuItem(
                        onTap: () async {
                          if (kIsWeb) {
                            await launchUrlString(
                              "https://mohammedaydan.github.io/Chat/privacy",
                            );
                            return;
                          }
                          Get.toNamed(PrivacyScreen.routeName);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.privacy_tip_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "privacy".tr,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      // End Test
                      PopupMenuItem(
                        onTap: () {
                          authController.signout();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "sign_out".tr,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  child: GetBuilder(
                    init: authController,
                    builder: (controller) {
                      return Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: MyMethods.bgColor2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: controller.user!.photoURL != null
                            ? CachedImage(imageUrl: controller.user!.photoURL!)
                            : Text(controller.user!.email![0].toUpperCase()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(NewChatScreen.routeName);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: MyMethods.bgColor2,
                      ),
                      child: Text(
                        "search".tr,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(GeminiChatScreen.routeName);
                },
                child: Padding(
                  padding: Get.locale != null
                      ? Get.locale!.languageCode.toString().startsWith("ar")
                          ? const EdgeInsets.only(left: 10)
                          : const EdgeInsets.only(right: 10)
                      : const EdgeInsets.only(right: 10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    // margin: const EdgeInsets.only(right: 10),
                    alignment: Alignment.center,
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: MyMethods.bgColor2,
                    ),
                    child:
                        Center(child: Image.asset("assets/images/google.png")),
                  ),
                ),
              ),
            ],
          ),
          GetBuilder(
            init: chatsController,
            builder: (controller) {
              if (controller.chatModels.isEmpty &&
                  controller.isLoading == true) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.chatModels.isEmpty &&
                  controller.isLoading == false) {
                return const Expanded(
                  child: Center(
                    child: Icon(
                      Icons.forum_rounded,
                      size: 200,
                      color: MyMethods.borderColor,
                    ),
                  ),
                );
              }

              return Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    if (controller.isLoading) ...[
                      const LinearProgressIndicator(
                        minHeight: 2,
                        color: Color.fromARGB(255, 49, 68, 97),
                        backgroundColor: MyMethods.bgColor2,
                      ),
                    ],
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.chatModels.length,
                      itemBuilder: (context, i) {
                        ChatModelF chatModelF = controller.chatModels[i];

                        if (chatModelF.type == "user" ||
                            chatModelF.type == null) {
                          return UserCard(
                            userData: chatModelF.user,
                            authController: authController,
                            lastMessage: GetLastMessage(
                              authController: authController,
                              chatModelF: chatModelF,
                            ),
                          );
                        } else {
                          return GroupCard(
                            groupData: chatModelF.group,
                            authController: authController,
                            lastMessage: GetLastMessageGroup(
                              authController: authController,
                              chatModelF: chatModelF,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 34, 50, 71),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        onPressed: () {
          Get.toNamed(NewChatScreen.routeName);
        },
        // child: const Icon(Icons.chat),
        label: Text("new_chat".tr),
        icon: const Icon(Icons.chat),
      ).animate().fadeIn(),
    );
  }
}
