import 'dart:async';

import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/views/v_w/new_versions.dart';
import 'package:chatapp/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

String appUrl =
    'https://drive.google.com/file/d/14Hyh4g6a5yloioTVwNdZn9CwcGU2DPV6/view?usp=sharing';

class NewVersion extends StatelessWidget {
  const NewVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "update_available".tr,
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 10),
            Text("new_version".tr),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("close".tr,
                          style: TextStyle(color: Colors.grey[400])),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryButton(
                      text: "update".tr,
                      borderRadius: BorderRadius.circular(50),
                      onPressed: () async {
                        await launchUrlString(
                            "http://chatapp.eb2a.com/download");
                        Get.back();
                      },
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
}

Future newVersion(String newVersion) async {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: MyMethods.bgColor,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      title: Text(
        "update_available".tr,
        style: TextStyle(color: Colors.grey[400]),
      ),
      content: Text("new_version".tr),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text("close".tr, style: TextStyle(color: Colors.grey[400])),
        ),
        PrimaryButton(
          text: "update".tr,
          borderRadius: BorderRadius.circular(50),
          // onPressed: () => fileDownloader(newVersion),
          onPressed: () async {
            Get.back();
            // await launchUrlString("http://chatapp.eb2a.com/download");
            await showVersionDialog();
          },
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

void fileDownloader(String newVersion) async {
  // MyMethods.showLoadingDialog();
  Get.back();
  await FileDownloader.downloadFile(
    url: appUrl,
    name: 'chatapp-v$newVersion.apk',
    onDownloadRequestIdReceived: (downloadId) {
      // show snackbar starting download
      Get.snackbar(
        'Downloading',
        'Download started',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    },
    onDownloadCompleted: (v) {
      Get.snackbar(
        'success'.tr,
        'Download completed',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    },
    notificationType: NotificationType.all,
  );
  // Get.back();
  // Get.back();
}
