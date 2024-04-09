import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/gemini_controller.dart';
import 'package:chatapp/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class GeminiChatScreen extends StatelessWidget {
  static const String routeName = "/GeminiChat";
  GeminiChatScreen({super.key});
  final GeminiController geminiController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: geminiController,
      builder: (geminiController) {
        return Scaffold(
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            backgroundColor: MyMethods.bgColor2,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: MyMethods.bgColor,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Center(
                              child: Text(
                                "G".toUpperCase(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gemini pro",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Row(
                      children: [],
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: geminiController.outputs.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    controller: geminiController.controller,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                    "assets/images/gemini-logo.png"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "+",
                              style: TextStyle(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 100,
                              child: Image.asset("assets/images/chat-logo.png"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "gemini_message_1".tr,
                            style: const TextStyle(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  controller: geminiController.controller,
                  reverse: true,
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                    bottom: MediaQuery.of(context).padding.bottom + 10,
                  ),
                  itemCount: geminiController.outputs.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    // geminiController.scrollToTheEnd();
                    final msg = geminiController.outputs[index];
                    if (msg.role == "User") {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: MyMethods.borderColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              backgroundColor: MyMethods.bgColor,
                              child: Center(
                                child: Text(
                                  "U",
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: ChtatConatiner(msg: msg)),
                          ],
                        ),
                      );
                    }
                    return ChtatConatiner(msg: msg);
                  },
                ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.only(
              top: 5,
              left: 10,
              right: 10,
              bottom: 7,
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            width: double.infinity,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              // color: MyMethods.bgColor2,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextInput(
                    onTap: () async {
                      await Future.delayed(150.milliseconds);
                      geminiController.scrollToTheEnd();
                    },
                    height: 50,
                    borderRadius: BorderRadius.circular(30),
                    label: "e_m".tr,
                    controller: geminiController.textEditingController,
                    onChanged: (c) {
                      geminiController.textEditingController.text = c;
                      geminiController.update();
                    },
                  ),
                ),
                if (geminiController.isLoading) ...[
                  Container(
                    width: 50,
                    height: 50,
                    margin: Get.locale != null
                        ? Get.locale!.languageCode.toString().startsWith("ar")
                            ? const EdgeInsets.only(right: 5)
                            : const EdgeInsets.only(left: 5)
                        : const EdgeInsets.only(left: 5),
                    alignment: Alignment.center,
                    transformAlignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: MyMethods.bgColor2,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const CircularProgressIndicator(),
                  ),
                ],
                if (!geminiController.isLoading) ...[
                  if (geminiController
                      .textEditingController.text.isNotEmpty) ...[
                    Container(
                      width: 50,
                      height: 50,
                      margin: Get.locale != null
                          ? Get.locale!.languageCode.toString().startsWith("ar")
                              ? const EdgeInsets.only(right: 5)
                              : const EdgeInsets.only(left: 5)
                          : const EdgeInsets.only(left: 5),
                      alignment: Alignment.center,
                      transformAlignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: MyMethods.bgColor2,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        onPressed: () {
                          final focus = FocusScope.of(context);
                          focus.unfocus();
                          geminiController.chat();
                        },
                        icon: const Icon(
                          Icons.send,
                          color: MyMethods.blueColor2,
                        ),
                      ),
                    ),
                  ]
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChtatConatiner extends StatelessWidget {
  ChtatConatiner({
    super.key,
    required this.msg,
  });

  final MsgGemini msg;
  final GeminiController geminiController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Markdown(
      softLineBreak: true,
      listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      data: msg.output ?? 'cannot generate data!',
      // selectable: true,
      onTapLink: (text, href, title) {
        if (href != null) {
          launchUrl(Uri.parse(href));
        }
      },
      styleSheet: MarkdownStyleSheet(
        code: const TextStyle(color: MyMethods.bgColor),
        codeblockPadding: const EdgeInsets.all(10),
        pPadding: const EdgeInsets.all(10),
      ),
    );
  }
}
