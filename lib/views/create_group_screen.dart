import 'dart:io';

import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/chats_controller.dart';
import 'package:chatapp/logic/controllers/create_group_controller.dart';
import 'package:chatapp/logic/models/chat_model_f.dart';
import 'package:chatapp/views/profiles/profile_screen.dart';
import 'package:chatapp/widgets/buttons/primary_button.dart';
import 'package:chatapp/widgets/cached_image.dart';
import 'package:chatapp/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupScreen extends StatelessWidget {
  static const String routeName = "/CreateGroup";
  CreateGroupScreen({super.key});

  final ChatsController chatsController = Get.find();
  final CreateGroupController controller = Get.put(CreateGroupController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          body: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextInput(
                          label: "enter_group_name".tr,
                          controller: controller.nameGroupEditingController,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: MyMethods.bgColor2,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          icon: controller.img == null
                              ? const Icon(
                                  Icons.image,
                                  color: Colors.white,
                                )
                              : CircleAvatar(
                                  backgroundColor: MyMethods.bgColor2,
                                  backgroundImage: FileImage(
                                    File(controller.img!.path),
                                  ),
                                ),
                          onPressed: () => _newImage(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: chatsController.chatModels.length,
                    itemBuilder: (context, index) {
                      ChatModelF chat = chatsController.chatModels[index];
                      if (chat.group != null) {
                        return const SizedBox();
                      }
                      return ListTile(
                        textColor: Colors.white,
                        onTap: () {
                          // Get.toNamed(ChatScreen.routeName,
                          //     arguments: chat.user);
                          controller.selectOrUnselect(chat.user!);
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              activeColor: MyMethods.blueColor2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              side: const BorderSide(
                                width: 2,
                                color: MyMethods.borderColor,
                              ),
                              value: controller.isSelected(chat.user!),
                              onChanged: (v) {
                                controller.selectOrUnselect(chat.user!);
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.selectOrUnselectAdmin(chat.user!);
                              },
                              child: Container(
                                // padding: const EdgeInsets.only(right: 15),

                                padding: Get.locale != null
                                    ? Get.locale!.languageCode
                                            .toString()
                                            .startsWith("ar")
                                        ? const EdgeInsets.only(left: 15)
                                        : const EdgeInsets.only(right: 15)
                                    : const EdgeInsets.only(right: 15),

                                decoration: BoxDecoration(
                                  color: MyMethods.bgColor2,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      checkColor: Colors.white,
                                      activeColor: MyMethods.blueColor2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      side: const BorderSide(
                                        width: 2,
                                        color: Colors.white,
                                      ),
                                      value: controller
                                          .isSelectedAdmin(chat.user!),
                                      onChanged: (v) {
                                        controller
                                            .selectOrUnselectAdmin(chat.user!);
                                      },
                                    ),
                                    Text("admin".tr),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text("${chat.user?.displayName}"),
                        leading: GestureDetector(
                          onTap: () {
                            Get.toNamed(ProfileScreen.routeName,
                                arguments: chat.user);
                          },
                          child: chat.user!.photoUrl != null
                              ? CachedImage(imageUrl: chat.user!.photoUrl!)
                              : Text(chat.user!.email![0].toUpperCase()),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.selectedUsers.isNotEmpty) ...[
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${"seleted".tr}: ${controller.selectedUsers.length}",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: MyMethods.bgColor2,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () => controller.unselectAll(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              Container(
                margin: const EdgeInsets.all(15),
                width: double.infinity,
                height: 75,
                decoration: BoxDecoration(
                  color: MyMethods.bgColor2,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: controller.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(15),
                        child: PrimaryButton(
                          text: "create".tr,
                          onPressed: controller.selectedUsers.isNotEmpty &&
                                  controller.nameGroupEditingController.text
                                      .isNotEmpty &&
                                  controller.img != null
                              ? () {
                                  controller.createGroup();
                                }
                              : null,
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _newImage(BuildContext context) async {
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
              XFile? img = await picker.pickImage(source: ImageSource.camera);
              if (img != null) {
                controller.img = img;
                controller.update();
              }
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
              XFile? img = await picker.pickImage(source: ImageSource.gallery);
              if (img != null) {
                controller.img = img;
                controller.update();
              }
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
