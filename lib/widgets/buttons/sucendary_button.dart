import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class SucendaryButton extends StatelessWidget {
  const SucendaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.padding,
    this.height,
  });

  final String text;
  final Callback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed ?? () => {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: padding ??
              const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 25,
              ),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: MyMethods.borderColor, width: 2),
            borderRadius: BorderRadius.circular(10),
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
