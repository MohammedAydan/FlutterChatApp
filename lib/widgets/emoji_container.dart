import 'package:chatapp/logic/controllers/chat_group_controller.dart';
import 'package:chatapp/widgets/buttons/danger_button.dart';
import 'package:chatapp/widgets/buttons/outlined_button.dart';
import 'package:emoji_selector/emoji_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmojiContainer extends StatelessWidget {
  const EmojiContainer({
    super.key,
    required this.controller,
  });

  final controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: EmojiSelector(
              //  padding: const EdgeInsets.all(10),
              withTitle: false,
              onSelected: (EmojiData s) {
                controller.textEditingController.text += s.char;
                print(s.char.length);
                print(s);
                print(s.char);
                controller.message = controller.textEditingController.text;
                controller.update();
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: Row(
              children: [
                DangerButton(
                  text: 'X',
                  height: 40,
                  onPressed: () {
                    try {
                      if (controller.textEditingController.text.isNotEmpty) {
                        if (controller.textEditingController.text.length > 1) {
                          controller.textEditingController.text =
                              controller.textEditingController.text.substring(
                                  0,
                                  controller.textEditingController.text.length -
                                      2);
                          controller.message =
                              controller.textEditingController.text;
                          print(
                              controller.textEditingController.text.toString());
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  //borderRadius: BorderRadius.circular(50),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MyOutlinedButton(
                    text: "Space",
                    onPressed: () {
                      controller.textEditingController.text += " ";
                      controller.message =
                          controller.textEditingController.text;
                      print(controller.textEditingController.text.toString());
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
