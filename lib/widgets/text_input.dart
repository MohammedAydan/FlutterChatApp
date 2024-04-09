import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    required this.label,
    this.controller,
    this.onChanged,
    this.initialValue,
    this.borderRadius,
    this.width,
    this.height,
    this.maxLines,
    this.maxLength,
    this.onTap, this.padding,
  });

  final String label;
  final TextEditingController? controller;
  final ValueChanged? onChanged;
  final String? initialValue;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final int? maxLines;
  final int? maxLength;
  final Callback? onTap;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        color: MyMethods.bgColor2,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).unfocus();
        },
        onTap: onTap,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        initialValue: initialValue,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: MyMethods.colorText2),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          border: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: MyMethods.borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: MyMethods.borderColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: MyMethods.borderColor, width: 1),
          ),
        ),
      ),
    );
  }
}
