import 'dart:io';

import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/chat_group_controller.dart';
import 'package:chatapp/widgets/text_input.dart';
import 'package:emoji_selector/emoji_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'emoji_container.dart';

class ChatGroupBottomNavBar extends StatelessWidget {
  const ChatGroupBottomNavBar({
    super.key,
    required this.controller,
  });

  final ChatGroupController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if (controller.isEmojiOpend) {
            controller.isEmojiOpend = !controller.isEmojiOpend;
            controller.update();
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Container(
          color: MyMethods.bgColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!controller.group.members!
                  .contains(controller.authController.user?.uid)) ...[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      "not_m_g".tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
              if (controller.group.members!
                  .contains(controller.authController.user?.uid)) ...[
                if (controller.image != null) ...[
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          top: 5,
                          left: 10,
                          right: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          color: MyMethods.bgColor2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.file(
                          File(controller.image!.path),
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            controller.image = null;
                            controller.update();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
                Container(
                  padding: const EdgeInsets.only(
                    top: 5,
                    left: 10,
                    right: 10,
                    bottom: 7,
                  ),
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  width: double.infinity,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    // color: MyMethods.bgColor2,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            TextInput(
                              padding: Get.locale != null
                                  ? Get.locale!.languageCode
                                          .toString()
                                          .startsWith("ar")
                                      ? const EdgeInsets.only(left: 40)
                                      : const EdgeInsets.only(right: 40)
                                  : const EdgeInsets.only(right: 40),
                              onTap: () {
                                controller.isEmojiOpend = false;
                                controller.update();
                              },
                              height: 50,
                              borderRadius: BorderRadius.circular(30),
                              label: "e_m".tr,
                              controller: controller.textEditingController,
                              onChanged: (value) => controller.message = value,
                            ),
                            // emoji btn
                            if (Get.locale != null &&
                                Get.locale!.languageCode
                                    .toString()
                                    .startsWith("ar")) ...[
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  margin: Get.locale != null
                                      ? Get.locale!.languageCode
                                              .toString()
                                              .startsWith("ar")
                                          ? const EdgeInsets.only(right: 5)
                                          : const EdgeInsets.only(left: 5)
                                      : const EdgeInsets.only(left: 5),
                                  alignment: Alignment.center,
                                  transformAlignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: MyMethods.bgColor2,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.emoji_emotions_rounded,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      controller.isEmojiOpend =
                                          !controller.isEmojiOpend;
                                      controller.update();
                                      // controller = null;
                                    },
                                  ),
                                ),
                              ),
                            ] else ...[
                              Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  margin: Get.locale != null
                                      ? Get.locale!.languageCode
                                              .toString()
                                              .startsWith("ar")
                                          ? const EdgeInsets.only(right: 5)
                                          : const EdgeInsets.only(left: 5)
                                      : const EdgeInsets.only(left: 5),
                                  alignment: Alignment.center,
                                  transformAlignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: MyMethods.bgColor2,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.emoji_emotions_rounded,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      controller.isEmojiOpend =
                                          !controller.isEmojiOpend;
                                      controller.update();
                                      // controller = null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        margin: Get.locale != null
                            ? Get.locale!.languageCode
                                    .toString()
                                    .startsWith("ar")
                                ? const EdgeInsets.only(right: 5)
                                : const EdgeInsets.only(left: 5)
                            : const EdgeInsets.only(left: 5),
                        alignment: Alignment.center,
                        transformAlignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: MyMethods.bgColor2,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                          onPressed: () => selectMedia(context),
                        ),
                      ),
                      if (controller.image != null ||
                          controller.message.isNotEmpty) ...[
                        if (controller.isLoading) ...[
                          Container(
                            width: 50,
                            height: 50,
                            margin: Get.locale != null
                                ? Get.locale!.languageCode
                                        .toString()
                                        .startsWith("ar")
                                    ? const EdgeInsets.only(right: 5)
                                    : const EdgeInsets.only(left: 5)
                                : const EdgeInsets.only(left: 5),
                            alignment: Alignment.center,
                            transformAlignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: MyMethods.bgColor2,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const CircularProgressIndicator(),
                          ),
                        ] else ...[
                          Container(
                            width: 50,
                            height: 50,
                            margin: Get.locale != null
                                ? Get.locale!.languageCode
                                        .toString()
                                        .startsWith("ar")
                                    ? const EdgeInsets.only(right: 5)
                                    : const EdgeInsets.only(left: 5)
                                : const EdgeInsets.only(left: 5),
                            alignment: Alignment.center,
                            transformAlignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: MyMethods.bgColor2,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              onPressed: () {
                                controller.sendMessage();
                              },
                              icon: const Icon(Icons.send,
                                  color: MyMethods.blueColor2),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ],
              controller.isEmojiOpend
                  ? EmojiContainer(controller: controller)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  selectMedia(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MyMethods.bgColor,
      elevation: 0,
      enableDrag: true,
      showDragHandle: true,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () async {
              Get.back();
              ImagePicker picker = ImagePicker();
              XFile? file = await picker.pickImage(
                source: ImageSource.camera,
              );
              controller.image = file;
              controller.update();
            },
            iconColor: Colors.white,
            textColor: MyMethods.colorText1,
            title: Text("camera".tr),
            leading: const CircleAvatar(
              radius: 20,
              backgroundColor: MyMethods.bgColor2,
              child: Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            onTap: () async {
              Get.back();
              ImagePicker picker = ImagePicker();
              XFile? file = await picker.pickImage(
                source: ImageSource.gallery,
              );
              controller.image = file;
              controller.update();
            },
            iconColor: Colors.white,
            textColor: MyMethods.colorText1,
            title: Text("gallery".tr),
            leading: const CircleAvatar(
              radius: 20,
              backgroundColor: MyMethods.bgColor2,
              child: Icon(
                Icons.image_rounded,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
