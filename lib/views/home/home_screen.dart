import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/logic/controllers/home_controller.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:chatapp/views/new_chat_screen.dart';
import 'package:chatapp/widgets/cached_image.dart';
import 'package:chatapp/widgets/text_input.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/user_card.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "/HomeScreen";
  HomeScreen({super.key});
  final AuthController authController = Get.find();
  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Home"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: TextInput(
                  label: "Search",
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            PopupMenuButton(
              color: MyMethods.bgColor2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: TextButton(
                      onPressed: () {
                        authController.signout();
                      },
                      child: Text(
                        "Profile",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    child: TextButton(
                      onPressed: () {
                        authController.signout();
                      },
                      child: Text(
                        "Settings",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    child: TextButton(
                      onPressed: () {
                        authController.signout();
                      },
                      child: const Text(
                        "Sign Out",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ];
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: MyMethods.bgColor2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: authController.user!.photoURL != null
                    ? CachedImage(imageUrl: authController.user!.photoURL!)
                    : Text(authController.user!.email![0].toUpperCase()),
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder(
        init: controller,
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!controller.isLoading && controller.users.isEmpty) {
            return const Center(
              child: Text("No users found"),
            );
          }
          return ListView.builder(
            itemCount: controller.users.length,
            itemBuilder: (context, i) {
              UserModel user = controller.users[i];
              return UserCard(userData: user, authController: authController);
            },
          );
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 49, 68, 97),
        foregroundColor: Colors.white,
        onPressed: () {
          Get.toNamed(NewChatScreen.routeName);
        },
        // child: const Icon(Icons.chat),
        label: const Text("Chat"),
        icon: const Icon(Icons.chat),
      ),
    );
  }
}
