import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CachedImage extends StatelessWidget {
  const CachedImage(
      {super.key,
      required this.imageUrl,
      this.borderRadius,
      this.width,
      this.height,
      this.fit});
  final String imageUrl;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Container(
        decoration: BoxDecoration(
          color: MyMethods.bgColor2,
          borderRadius: borderRadius ?? BorderRadius.circular(50),
        ),
        child: const Center(
          child: Icon(
            Icons.image_rounded,
            color: MyMethods.bgColor,
          ),
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      width: width ?? 45,
      height: height ?? 45,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(50),
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class CachedImageFull extends StatelessWidget {
  const CachedImageFull({
    super.key,
    required this.imageUrl,
    this.borderRadius,
    this.width,
    this.height,
    this.fit,
  });
  final String imageUrl;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      width: Get.width,
      // width: width,
      // height: height,
      fit: BoxFit.fitWidth,
      height: height ?? Get.height * 0.35,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(0),
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
          ),
        ),
      ),
    );
  }
}
