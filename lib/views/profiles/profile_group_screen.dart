import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/logic/controllers/chat_group_controller.dart';
import 'package:chatapp/logic/controllers/chats_controller.dart';
import 'package:chatapp/logic/controllers/profile_group_controller.dart';
import 'package:chatapp/logic/logic/home_logic_v2.dart';
import 'package:chatapp/logic/logic/home_logic_v3.dart';
import 'package:chatapp/logic/logic/logic.dart';
import 'package:chatapp/logic/models/chat_model_f.dart';
import 'package:chatapp/logic/models/group_model.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:chatapp/views/profiles/profile_screen.dart';
import 'package:chatapp/widgets/buttons/danger_button.dart';
import 'package:chatapp/widgets/buttons/outlined_button.dart';
import 'package:chatapp/widgets/buttons/primary_button.dart';
import 'package:chatapp/widgets/buttons/success_button.dart';
import 'package:chatapp/widgets/cached_image.dart';
import 'package:chatapp/widgets/text_input.dart';
import 'package:chatapp/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileGroupScreen extends StatelessWidget {
  static const String routeName = "/ProfileGroupScreen";
  ProfileGroupScreen({super.key});
  final AuthController authController = Get.find();
  final ProfileGroupController profileGroupController =
      Get.put(ProfileGroupController());
  final ChatsController chatsController = Get.find();

  @override
  Widget build(BuildContext context) {
    // String uid = Get.arguments;
    GroupModel? groupModel = Get.arguments;
    if (groupModel == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    bool isAdmin = authController.user?.uid == groupModel.ownerId ||
        groupModel.admins!.contains(authController.user?.uid);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              height: 295,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      color: MyMethods.bgColor2,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: isUserAndImgNotNull(groupModel)
                        ? CachedImageFull(
                            imageUrl: groupModel.photoUrl!,
                            borderRadius: BorderRadius.circular(20),
                            fit: BoxFit.fitWidth,
                          )
                        : const Center(
                            child: Icon(Icons.image_rounded),
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: isUserAndImgNotNull(groupModel)
                                ? CachedImage(
                                    width: 150,
                                    height: 150,
                                    imageUrl: groupModel.photoUrl!,
                                    borderRadius: BorderRadius.circular(100),
                                  )
                                : const Center(
                                    child: Icon(Icons.image_rounded),
                                  ),
                          ),
                          if (isAdmin) ...[
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(202, 30, 41, 59),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    _newImage(context, groupModel);
                                  },
                                  icon: Icon(
                                    Icons.add_photo_alternate,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // controls for owner or admin
          if (isAdmin) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: MyMethods.bgColor2,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () => _addUser(context, groupModel),
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ],

          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${groupModel.displayName}"),
                if (isAdmin) ...[
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 1,
                        color: MyMethods.bgColor2,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => _editDisplayName(groupModel),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: MyMethods.bgColor2,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                // color: MyMethods.bgColor2,
                border: Border.all(width: 1, color: MyMethods.bgColor2),
              ),
              child: Text(
                "owner".tr,
                style: TextStyle(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ),
          groupModel.ownerId == null
              ? const SizedBox()
              : FutureBuilder(
                  future: ChatLogic.getUserInCash(groupModel.ownerId!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingUser();
                    }

                    UserModel? userModel = snapshot.data;

                    ChatLogic.getUser(groupModel.ownerId!)
                        .then((value) => userModel = value);

                    return UserCard(
                      userData: userModel,
                      authController: authController,
                      my: authController.user?.uid == userModel?.uid,
                    );
                  },
                ),
          const Divider(color: MyMethods.borderColor),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                // color: MyMethods.bgColor2,
                border: Border.all(width: 1, color: MyMethods.bgColor2),
              ),
              child: Text(
                "members".tr,
                style: TextStyle(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: groupModel.members?.length,
            itemBuilder: (context, i) {
              return FutureBuilder(
                future: ChatLogic.getUserInCash(groupModel.members![i]),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingUser();
                  }
                  UserModel? userModel = snapshot.data;

                  ChatLogic.getUser(groupModel.members![i])
                      .then((value) => userModel = value);

                  return UserCard(
                    groupModel: groupModel,
                    isAdminControls: isAdmin,
                    userData: userModel,
                    authController: authController,
                    my: authController.user?.uid == userModel?.uid,
                    isAdmin: groupModel.admins!.contains(userModel?.uid)
                        ? true
                        : false,
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 70,
        decoration: const BoxDecoration(
          color: MyMethods.bgColor2,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DangerButton(
              text: "exit_the_group".tr,
              width: double.infinity,
              onPressed: () async {
                try {
                  MyMethods.showLoadingDialog();
                  await HomeLogicV3.signOutForGroup(groupModel.id!);
                } catch (e) {
                  print(e);
                } finally {
                  Get.back();
                  Get.back();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  bool isUserAndImgNotNull(GroupModel? groupModel) {
    if (groupModel != null && groupModel.photoUrl != null) {
      return true;
    }
    return false;
  }

  void _addUser(BuildContext context, GroupModel groupModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MyMethods.bgColor,
      elevation: 0,
      enableDrag: true,
      showDragHandle: true,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatsController.chatModels.length,
              itemBuilder: (context, i) {
                ChatModelF chat = chatsController.chatModels[i];
                if (chat.user != null) {
                  return ListTile(
                    textColor: Colors.white,
                    onTap: () {
                      // Get.toNamed(ChatScreen.routeName,
                      //     arguments: chat.user);
                      // controller.selectOrUnselect(chat.user!);
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // controller.selectOrUnselectAdmin(chat.user!);
                            if (!groupModel.members!.contains(chat.user?.uid)) {
                              Get.dialog(
                                Dialog(
                                  elevation: 0,
                                  backgroundColor: MyMethods.bgColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("are_you_sure".tr),
                                        const SizedBox(height: 30),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SuccessButton(
                                                width: double.infinity,
                                                onPressed: () {
                                                  try {
                                                    HomeLogicV2
                                                        .addNewUserForGroup(
                                                      chat.user!.uid,
                                                      false,
                                                      groupModel.id!,
                                                    );
                                                  } catch (e) {
                                                    print(e);
                                                  } finally {
                                                    Get.back();
                                                    Get.back();
                                                    Get.back();
                                                    Get.back();
                                                  }
                                                },
                                                text: "add_member".tr,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: PrimaryButton(
                                                width: double.infinity,
                                                onPressed: () async {
                                                  try {
                                                    MyMethods
                                                        .showLoadingDialog();
                                                    await HomeLogicV2
                                                        .addNewUserForGroup(
                                                      chat.user!.uid,
                                                      true,
                                                      groupModel.id!,
                                                    );
                                                  } catch (e) {
                                                    print(e);
                                                  } finally {
                                                    Get.back();
                                                    Get.back();
                                                    Get.back();
                                                    Get.back();
                                                  }
                                                },
                                                text: "add_admin".tr,
                                              ),
                                            ),
                                          ],
                                        ),
                                        MyOutlinedButton(
                                          width: double.infinity,
                                          onPressed: () {
                                            Get.back();
                                            Get.back();
                                          },
                                          text: "cancel".tr,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: MyMethods.bgColor2,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (groupModel.members!
                                    .contains(chat.user?.uid)) ...[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("exists".tr),
                                  ),
                                ] else ...[
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.add_rounded),
                                  )
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text("${chat.user?.displayName}"),
                    leading: GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          ProfileScreen.routeName,
                          arguments: chat.user,
                        );
                      },
                      child: chat.user!.photoUrl != null
                          ? CachedImage(imageUrl: chat.user!.photoUrl!)
                          : Text(chat.user!.email![0].toUpperCase()),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _newImage(BuildContext context, GroupModel groupModel) async {
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
              MyMethods.showLoadingDialog();
              try {
                ImagePicker picker = ImagePicker();
                final img = await picker.pickImage(source: ImageSource.camera);
                if (img != null) {
                  await HomeLogicV3.updateImgForGroup(groupModel.id!, img);
                }
              } catch (e) {
                Get.snackbar('error'.tr, 'e_o'.tr);
              } finally {
                Get.back();
                Get.back();
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
              MyMethods.showLoadingDialog();
              try {
                ImagePicker picker = ImagePicker();
                final img = await picker.pickImage(source: ImageSource.gallery);
                if (img != null) {
                  await HomeLogicV3.updateImgForGroup(groupModel.id!, img);
                }
              } catch (e) {
                Get.snackbar('error'.tr, 'e_o'.tr);
              } finally {
                Get.back();
                Get.back();
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

  void _editDisplayName(GroupModel? groupModel) {
    profileGroupController.displayNameForGroupEditController.text =
        groupModel!.displayName!;
    profileGroupController.update();
    Get.dialog(
      Dialog(
        elevation: 0,
        backgroundColor: MyMethods.bgColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("edit_name".tr),
              const SizedBox(height: 20),
              TextInput(
                controller:
                    profileGroupController.displayNameForGroupEditController,
                label: "enter_group_name".tr,
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                width: double.infinity,
                onPressed: () {
                  profileGroupController.updateDisplayName();
                },
                text: "update".tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingUser extends StatelessWidget {
  const LoadingUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyMethods.borderColor,
      child: ListTile(
        title: Container(
          width: 20,
          height: 13,
          decoration: BoxDecoration(
            color: MyMethods.bgColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        leading: GestureDetector(
          child: const SizedBox(
            // Wrap the leading widget with a Container
            width: 45, // Set a fixed width
            height: 45, // Set a fixed height
            child: Center(
              child: CircleAvatar(
                backgroundColor: MyMethods.bgColor,
              ),
            ),
          ),
        ),
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .shimmer(
          delay: const Duration(milliseconds: 1000),
          duration: const Duration(milliseconds: 500),
        );
  }
}
