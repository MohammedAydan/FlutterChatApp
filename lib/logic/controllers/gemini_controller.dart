import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:flutter_gemini/src/models/candidates/candidates.dart';

class GeminiController extends GetxController {
  final gemini = Gemini.instance;
  TextEditingController textEditingController = TextEditingController();
  ScrollController controller = ScrollController();
  List<MsgGemini> outputs = [];
  bool isLoading = false;

  void chat() {
    String? message = textEditingController.text.trim();
    if (message.isEmpty) {
      return;
    }
    outputs.add(
      MsgGemini(i: outputs.length + 1, role: "User", output: message),
    );
    isLoading = true;
    scrollToTheEnd();
    update();
    
    try {
      gemini.streamGenerateContent(message).listen((Candidates event) {
        outputs.add(
          MsgGemini(
            i: outputs.length + 1,
            output: event.output,
            role: "Gemini",
          ),
        );
        scrollToTheEnd();
        update();
        scrollToTheEnd();
      }).onDone(() {
        textEditingController.clear();
        isLoading = false;
        scrollToTheEnd();
        update();
      });
    } catch (e) {
      print(e);
    }
  }

  void scrollToTheEnd() {
    // controller.jumpTo(controller.position.maxScrollExtent);
    outputs.sort((a, b) => b.i! - a.i!);
    update();
  }
}

class MsgGemini {
  int? i;
  String? role;
  String? output;

  MsgGemini({
    required this.i,
    required this.role,
    required this.output,
  });
}
