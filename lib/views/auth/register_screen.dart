import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/Widgets/buttons/button_select_file.dart';
import 'package:chatapp/Widgets/buttons/primary_button.dart';
import 'package:chatapp/Widgets/text_input.dart';
import 'package:chatapp/widgets/lang_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = '/Register';

  RegisterScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text("register".tr),
          centerTitle: true,
          actions: const [
            LangButton(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'register_screen'.tr,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (controller.error != "") ...[
                      Text(
                        controller.error,
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                    const SizedBox(height: 10),
                    TextInput(
                      label: 'e_d_n'.tr,
                      controller: controller.displayNameController,
                    ),
                    const SizedBox(height: 10),
                    TextInput(
                      label: 'e_e'.tr,
                      controller: controller.emailController,
                    ),
                    const SizedBox(height: 10),
                    ButtonSelectFile(
                      onPressed: () {
                        _newImage(context);
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.image, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            "select_image".tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextInput(
                      label: 'e_p'.tr,
                      controller: controller.passwordController,
                    ),
                    const SizedBox(height: 20),
                    if (controller.isLoading) ...[
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ] else ...[
                      PrimaryButton(
                        text: "register".tr,
                        width: double.infinity,
                        onPressed: () {
                          controller.register();
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
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
