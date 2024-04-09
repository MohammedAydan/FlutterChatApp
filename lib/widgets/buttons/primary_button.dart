import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.text,
    this.onPressed,
    this.width,
    this.padding,
    this.height,
    this.child, this.borderRadius,
  });

  final String? text;
  final Widget? child;
  final Callback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: MyMethods.blueColor1,
          padding: padding ??
              const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 25,
              ),
          shape: RoundedRectangleBorder(
            borderRadius:borderRadius?? BorderRadius.circular(10),
          ),
        ),
        child: child ??
            Text(
              "$text",
              style: const TextStyle(color: MyMethods.colorText1),
            ),
      ),
    );
  }
}
