import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LangButton extends StatelessWidget {
  const LangButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyMethods.bgColor,
          shadowColor: MyMethods.bgColor2,
          foregroundColor: Colors.white,
          surfaceTintColor: MyMethods.bgColor2,
          elevation: 0,
        ),
        onPressed: changeLang,
        icon: const Icon(Icons.language_rounded),
        label: Text(Get.locale?.languageCode == "en" ? "AR" : "EN"),
      ),
    );
  }

  void changeLang() {
    // print("1");
    // print(Get.locale);
    // print(Get.deviceLocale);
    if (Get.locale!.languageCode.contains("en")) {
      Get.updateLocale(const Locale("ar"));
      GetStorage().write("lang", "ar");
    } else if (Get.locale!.languageCode.contains("ar")) {
      Get.updateLocale(const Locale("en"));
      GetStorage().write("lang", "en");
    }
  }
}
