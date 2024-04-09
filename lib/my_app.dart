import 'dart:io';

import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/router.dart';
import 'package:chatapp/themes/dark.dart';
import 'package:chatapp/tr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_storage/get_storage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: <NavigatorObserver>[
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      // themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: dark,
      getPages: getPages,
      translations: TR(),
      locale: getLocale,
      fallbackLocale: const Locale('en'),
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 700) {
              return Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    // color: MyMethods.bgColor2,
                    gradient: LinearGradient(
                      tileMode: TileMode.mirror,
                      transform: GradientRotation(2),
                      colors: [
                        MyMethods.bgColor,
                        MyMethods.bgColor2,
                        MyMethods.blueColor1,
                        MyMethods.blueColor2,
                        Colors.white,
                        MyMethods.blueColor2,
                        MyMethods.blueColor1,
                        MyMethods.bgColor2,
                        MyMethods.bgColor,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(30),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          tileMode: TileMode.mirror,
                          transform: GradientRotation(90),
                          colors: [
                            MyMethods.bgColor,
                            MyMethods.blueColor1,
                            MyMethods.bgColor2,
                            MyMethods.blueColor2,
                            Colors.white,
                          ],
                        ),
                      ),
                      child: Container(
                        width: 500,
                        constraints: const BoxConstraints(maxWidth: 500),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          // border: Border.all(width: 3, color: Colors.white),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: child ?? const SizedBox(),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            return child ?? const SizedBox();
          },
        );
      },
    );
  }

  Locale get getLocale {
    if (GetStorage().hasData("lang")) {
      return Locale(GetStorage().read("lang") ?? "en");
    }

    if (Get.deviceLocale != null) {
      if (Get.deviceLocale!.languageCode.startsWith("ar")) {
        return const Locale("ar");
      }
      return const Locale("en");
    } else {
      return const Locale("en");
    }
  }
}
