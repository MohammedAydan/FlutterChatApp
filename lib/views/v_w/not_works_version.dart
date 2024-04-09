import 'package:chatapp/widgets/buttons/primary_button.dart';
import 'package:chatapp/widgets/lang_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatapp/views/v_w/new_versions.dart';

class NotWorksVersion extends StatelessWidget {
  const NotWorksVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(),
        actions: const [
          LangButton(),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // Adjust color as needed
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/chat-logo.png",
                    width: 70,
                    height: 70,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "ChatApp",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'stopped_working_message'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'new_version'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                borderRadius: BorderRadius.circular(50),
                onPressed: () async {
                  await showVersionDialog();
                  // await launchUrlString("http://chatapp.eb2a.com/download");
                },
                text: "update".tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
