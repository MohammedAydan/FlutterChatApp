import 'package:chatapp/widgets/lang_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotWorksApp extends StatelessWidget {
  const NotWorksApp({super.key});

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
          padding: const EdgeInsets.all(20),
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
                  color: Colors.white, // Adjust color as needed
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'app_no_works'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[400], // Adjust color as needed
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
