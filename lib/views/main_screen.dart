import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  static const String routeName = '/';

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            ClipOval(
              child: Image.asset(
                "assets/images/logo-1.png",
                width: 100,
                height: 100,
              ),
            ),
            const Text(
              "CHATAPP",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 150,
              child: LinearProgressIndicator(
                minHeight: 3,
                color: MyMethods.colorText2,
                backgroundColor: MyMethods.bgColor2,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // const CircularProgressIndicator(),
            const Spacer(flex: 2),
            const Text(
              "Powerd by",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: MyMethods.colorText2,
              ),
            ),
            const Text(
              "MAG",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
