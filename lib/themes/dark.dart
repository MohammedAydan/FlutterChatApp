import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:flutter/material.dart';

var dark = ThemeData(
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: MyMethods.colorText1,
    ),
    bodyMedium: TextStyle(
      color: MyMethods.colorText1,
    ),
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    backgroundColor: MyMethods.bgColor,
    // color: Colors.white,
    titleTextStyle: TextStyle(
      color: MyMethods.colorText1,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: MyMethods.colorText1,
    ),
    shape: Border(
      bottom: BorderSide(
        color: MyMethods.borderColor,
        width: 1,
      ),
    ),
  ),
  scaffoldBackgroundColor: MyMethods.bgColor,
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: MyMethods.blueColor1,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: MyMethods.bgColor,
    selectedItemColor: MyMethods.colorText1,
    unselectedItemColor: MyMethods.colorText2,
  ),
);
