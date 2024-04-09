import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class ButtonSelectFile extends StatelessWidget {
  const ButtonSelectFile({super.key, this.onPressed, this.label, this.child});

  final Callback? onPressed;
  final String? label;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: MyMethods.bgColor2,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: child ??
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.attach_file,
                  color: MyMethods.blueColor1,
                ),
                const SizedBox(width: 10),
                Text(
                  label ?? 'Select File',
                  style: const TextStyle(
                    color: MyMethods.colorText2,
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
