import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/home_controller.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:chatapp/views/chat/chat_screen.dart';
import 'package:chatapp/views/create_group_screen.dart';
import 'package:chatapp/views/profiles/profile_screen.dart';
import 'package:chatapp/widgets/buttons/outlined_button.dart';
import 'package:chatapp/widgets/cached_image.dart';
import 'package:chatapp/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewChatScreen extends StatelessWidget {
  static const String routeName = "/NewChat";

  NewChatScreen({super.key});
  final HomeController controller = Get.find();
  final bool showGB = true;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (controller) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            // vertical: 10,
                          ),
                          child: TextInput(
                            maxLines: 1,
                            controller: controller.searchController,
                            label: "e_e".tr,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      if (!controller.isSearching) ...[
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: MyMethods.bgColor2,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              controller.searchUsers();
                            },
                          ),
                        ),
                        if (controller.searchController.text.isNotEmpty) ...[
                          const SizedBox(width: 5),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: MyMethods.bgColor2,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.clear_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                controller.cleanSearch();
                              },
                            ),
                          ),
                        ],
                      ],
                      if (controller.isSearching) ...[
                        Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: MyMethods.bgColor2,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const CircularProgressIndicator(),
                        ),
                      ],
                    ],
                  ),
                ),
                showGB
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 55,
                          child: MyOutlinedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "create_group".tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.group_add_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            onPressed: () {
                              Get.toNamed(CreateGroupScreen.routeName);
                            },
                          ),
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.searchUsersList.length,
                    itemBuilder: (context, index) {
                      UserModel user = controller.searchUsersList[index];
                      return ListTile(
                        textColor: Colors.white,
                        title: Text("${user.displayName}"),
                        subtitle: Text("${user.email}"),
                        // subtitle: const Text("User Email"),
                        leading: GestureDetector(
                          onTap: () {
                            Get.toNamed(ProfileScreen.routeName,
                                arguments: user);
                          },
                          child: user.photoUrl != null
                              ? CachedImage(imageUrl: user.photoUrl!)
                              : Text(user.email![0].toUpperCase()),
                        ),
                        onTap: () {
                          Get.toNamed(ChatScreen.routeName, arguments: user);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
