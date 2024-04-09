import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/widgets/buttons/primary_button.dart';
import 'package:chatapp/widgets/cached_image.dart';
import 'package:chatapp/widgets/text_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileScreen extends StatelessWidget {
  static const String routeName = "/MyProfile";
  MyProfileScreen({super.key});
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: MyMethods.bgColor2,
            ),
            child: GetBuilder(
                init: authController,
                builder: (controller) {
                  return IconButton(
                    onPressed: () {
                      controller.displayNameEditController.text =
                          controller.user!.displayName!;
                      _edit(controller.user);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  );
                }),
          ),
        ],
      ),
      body: GetBuilder(
          init: authController,
          builder: (controller) {
            return ListView(
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
                          child: isUserAndImgNotNull(controller)
                              ? CachedImageFull(
                                  imageUrl: controller.user!.photoURL!,
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
                                  child: isUserAndImgNotNull(controller)
                                      ? CachedImage(
                                          width: 150,
                                          height: 150,
                                          imageUrl: controller.user!.photoURL!,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        )
                                      : const Center(
                                          child: Icon(Icons.image_rounded),
                                        ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(202, 30, 41, 59),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        _newImage(context);
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Text("${controller.user?.displayName}"),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text("${controller.user?.email}"),
                ),
              ],
            );
          }),
    );
  }

  bool isUserAndImgNotNull(AuthController controller) {
    if (controller.user != null && controller.user!.photoURL != null) {
      return true;
    }
    return false;
  }

  void _edit(User? user) {
    Get.dialog(
      Dialog(
        elevation: 0,
        backgroundColor: MyMethods.bgColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("edit_profile".tr),
              const SizedBox(height: 20),
              TextInput(
                controller: authController.displayNameEditController,
                label: "display_name".tr,
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                width: double.infinity,
                onPressed: () {
                  authController.updateProfile();
                },
                text: "update".tr,
              ),
            ],
          ),
        ),
      ),
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
              authController.updateProfileImage(ImageSource.camera);
            },
            iconColor: Colors.white,
            textColor: MyMethods.colorText1,
            title: Text("camera".tr),
            leading: CircleAvatar(
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
              authController.updateProfileImage(ImageSource.gallery);
            },
            iconColor: Colors.white,
            textColor: MyMethods.colorText1,
            title: Text("gallery".tr),
            leading: CircleAvatar(
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
