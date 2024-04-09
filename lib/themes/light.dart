import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:flutter/material.dart';

var light = ThemeData(
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: MyMethods.colorText1L,
    ),
    bodyMedium: TextStyle(
      color: MyMethods.colorText1L,
    ),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    backgroundColor: MyMethods.bgColorL,
    // color: Colors.white,
    titleTextStyle: TextStyle(
      color: MyMethods.colorText1L,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: MyMethods.colorText1L,
    ),
    shape: Border(
      bottom: BorderSide(
        color: MyMethods.borderColorL,
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
