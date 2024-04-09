import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class DangerButton extends StatelessWidget {
  const DangerButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.padding,
    this.height, this.borderRadius,
  });

  final String text;
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
        onPressed: onPressed ?? () => {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: padding ??
              const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 25,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: MyMethods.colorText1),
        ),
      ),
    );
  }
}
