import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/logic/logic.dart';
import 'package:chatapp/logic/models/msg_model.dart';
import 'package:chatapp/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MessageContainer extends StatelessWidget {
  final bool isCurrentUserMessage;
  final Msg msg;

  const MessageContainer({
    super.key,
    required this.isCurrentUserMessage,
    required this.msg,
  });

  @override
  Widget build(BuildContext context) {
    if (!isCurrentUserMessage) {
      if (msg.readAt == null) {
        ChatLogic.updateReadMessage(msg);
      }
    }

    return GestureDetector(
      onLongPress: () {
        if (msg.message!.isNotEmpty) {
          copyToClipboard(msg.message!);
          Get.snackbar(
            'Alert',
            'Copy text success',
            colorText: Colors.white,
            backgroundColor: MyMethods.bgColor2,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: isCurrentUserMessage
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: Get.width * 0.8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCurrentUserMessage
                    ? const Color.fromARGB(255, 49, 68, 97)
                    // ? Colors.white
                    // ? MyMethods.blueColor1
                    : MyMethods.bgColor2,
                borderRadius: BorderRadius.only(
                  bottomLeft: !isCurrentUserMessage
                      ? const Radius.circular(20)
                      : Radius.zero,
                  bottomRight: !isCurrentUserMessage
                      ? Radius.zero
                      : const Radius.circular(20),
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  if (msg.message != null && msg.message!.isNotEmpty) ...[
                    GestureDetector(
                      onTap: () {
                        if (msg.message!.contains("https://")) {
                          launchUrlString(
                            "https://${msg.message!.split("https://").last.split(" ").first}",
                          );
                        } else if (msg.message!.contains("http://")) {
                          launchUrlString(
                            "http://${msg.message!.split("http://").last.split(" ").first}",
                          );
                        }
                      },
                      child: Text(
                        "${msg.message}",
                        style: TextStyle(
                          color: isCurrentUserMessage
                              ? MyMethods.colorText1
                              // ? MyMethods.bgColor
                              : MyMethods.colorText1,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                  if (msg.media != null) ...[
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        _showImageDialog(msg.media!);
                      },
                      child: CachedImageFull(
                        imageUrl: msg.media!,
                        borderRadius: BorderRadius.circular(15),
                        fit: BoxFit.contain,
                        // width: Get.width,
                        // height: Get.width,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCurrentUserMessage) ...[
                    _buildReadStatusIcon(),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    ChatLogic.getFormattedDate(msg.createdAt!),
                    style: const TextStyle(
                      color: MyMethods.colorText2,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadStatusIcon() {
    if (msg.storeMsgAt == null) {
      return const Icon(
        Icons.done_rounded,
        size: 15,
        color: MyMethods.bgColor2,
      );
    }
    return Icon(
      Icons.done_all_rounded,
      size: 15,
      color: msg.readAt == null ? MyMethods.bgColor2 : MyMethods.blueColor2,
    );
  }

  void _showImageDialog(String imageUrl) {
    Get.dialog(
      Stack(
        children: [
          CachedImageFull(
            imageUrl: msg.media!,
            borderRadius: BorderRadius.circular(15),
            width: Get.width,
            height: Get.height,
            fit: BoxFit.contain,
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                color: MyMethods.bgColor2,
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                highlightColor: MyMethods.bgColor,
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
