import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/logic/logic/home_logic_v2.dart';
import 'package:chatapp/logic/logic/logic.dart';
import 'package:chatapp/logic/models/chat_model_f.dart';
import 'package:chatapp/logic/models/msg_group_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetLastMessageGroup extends StatelessWidget {
  const GetLastMessageGroup({
    super.key,
    required this.authController,
    required this.chatModelF,
  });

  final AuthController authController;
  final ChatModelF chatModelF;

  @override
  Widget build(BuildContext context) {
    if (chatModelF.lastMessageId == null) {
      return SizedBox(
        child: Text(
          "${"no_messages".tr} 🎉",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey.shade400,
          ),
        ),
      );
    }
    if (chatModelF.type == null) {
      return const SizedBox();
    }
    return StreamBuilder(
      stream: chatModelF.type == "user"
          ? HomeLogicV2.getMessageById(
              authController.user!.uid,
              chatModelF.user!.uid,
              chatModelF.lastMessageId!,
            )
          : HomeLogicV2.getMessageByIdForGroup(
              chatModelF.id!,
              chatModelF.lastMessageId!,
            ),
      builder: (context, snapshot) {
        if (!snapshot.hasData &&
            snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.data() == null) {
          return const SizedBox();
        }

        MsgGroup? msg = MsgGroup.fromJson(
          snapshot.data!.data() as Map<String, dynamic>,
        );

        bool isCurrentUserMessage = msg.userId == authController.user!.uid;
        List<String>? members = chatModelF.group?.members!
            .where((e) => e != authController.user?.uid)
            .toList();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                if (isCurrentUserMessage) ...[
                  Icon(
                    msg.readAt == members
                        ? Icons.done_all_rounded
                        : Icons.done_all_rounded,
                    color: msg.readAt?.length == members?.length
                        ? MyMethods.blueColor2
                        : MyMethods.bgColor2,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                ],
                SizedBox(
                  width: Get.width * 0.5,
                  child: Text(
                    "${"message".tr}: ${msg.message}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Text(
                ChatLogic.getFormattedDate(msg.createdAt!),
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
                textAlign: TextAlign.end,
              ),
            ),
            if (!msg.readAt!.contains(authController.user?.uid) &&
                !isCurrentUserMessage) ...[
              const SizedBox(width: 5),
              const Icon(
                Icons.radio_button_checked,
                color: MyMethods.blueColor2,
                size: 15,
              ),
              const SizedBox(width: 5),
            ],
          ],
        );
      },
    );
  }
}
