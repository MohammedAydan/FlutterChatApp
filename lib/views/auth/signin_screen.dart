import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/views/auth/register_screen.dart';
import 'package:chatapp/views/v_w/new_versions.dart';
import 'package:chatapp/widgets/buttons/outlined_button.dart';
import 'package:chatapp/widgets/buttons/primary_button.dart';
import 'package:chatapp/widgets/buttons/success_button.dart';
import 'package:chatapp/widgets/lang_button.dart';
import 'package:chatapp/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninScreen extends StatelessWidget {
  static const String routeName = '/SignIn';

  SigninScreen({super.key});

  final AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    final arguments = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("login".tr),
        centerTitle: true,
        actions: const [
          LangButton(),
        ],
      ),
      body: GetBuilder(
        init: controller,
        builder: (controller) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'login_screen'.tr,
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
                    if (arguments != "" && arguments != null) ...[
                      Text(
                        arguments.toString(),
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                    const SizedBox(height: 10),
                    TextInput(
                      label: 'e_e'.tr,
                      controller: controller.emailController,
                    ),
                    const SizedBox(height: 10),
                    TextInput(
                      label: 'e_p'.tr,
                      controller: controller.passwordController,
                    ),
                    const SizedBox(height: 30),
                    controller.isLoading
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                            text: "login".tr,
                            width: double.infinity,
                            onPressed: () {
                              focusNode.unfocus();
                              controller.signin();
                            },
                          ),
                    const SizedBox(height: 10),
                    MyOutlinedButton(
                      width: double.infinity,
                      text: "register_now".tr,
                      onPressed: () => Get.toNamed(RegisterScreen.routeName),
                    ),
                    const SizedBox(height: 30),
                    PrimaryButton(
                      width: double.infinity,
                      onPressed: () {
                        focusNode.unfocus();
                        controller.signInWithGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/google.png",
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "s_w_g".tr,
                            style: const TextStyle(color: MyMethods.colorText1),
                          ),
                        ],
                      ),
                    ),
                    // SuccessButton(
                    //   width: double.infinity,
                    //   text: "Dialog For Testing",
                    //   onPressed: () {
                    //     showVersionDialog();
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
