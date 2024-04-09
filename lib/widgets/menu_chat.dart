import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/widgets/buttons/danger_button.dart';
import 'package:chatapp/widgets/buttons/outlined_button.dart';
import 'package:chatapp/widgets/buttons/primary_button.dart';
import 'package:chatapp/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuChat extends StatelessWidget {
  const MenuChat({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: MyMethods.bgColor2,
      elevation: 0,
      iconColor: Colors.white,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      position: PopupMenuPosition.under,
      popUpAnimationStyle: AnimationStyle(curve: Curves.decelerate),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            Get.dialog(
              Dialog(
                elevation: 0,
                backgroundColor: MyMethods.bgColor,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Are you sure ?"),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: MyOutlinedButton(
                              text: "Close",
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DangerButton(
                              width: double.infinity,
                              onPressed: () {
                                Get.back();
                              },
                              text: "Delete",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: const Text(
            "Delete chat",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            Get.dialog(
              Dialog(
                elevation: 0,
                backgroundColor: MyMethods.bgColor,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Report the user"),
                      const SizedBox(height: 20),
                      const TextInput(
                        label: "Enter report",
                        maxLength: 200,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: MyOutlinedButton(
                              text: "Close",
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: PrimaryButton(
                              width: double.infinity,
                              onPressed: () {
                                Get.back();
                              },
                              text: "Send",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: Text(
            "report",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            Get.dialog(
              Dialog(
                elevation: 0,
                backgroundColor: MyMethods.bgColor,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Block the user"),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: MyOutlinedButton(
                              text: "Close",
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DangerButton(
                              width: double.infinity,
                              onPressed: () {
                                Get.back();
                              },
                              text: "Block",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: Text(
            "Block",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
      child: const Icon(Icons.more_vert),
    );
  }
}
