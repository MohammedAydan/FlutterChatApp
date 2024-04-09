import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/logic/controllers/auth_controller.dart';
import 'package:chatapp/logic/models/user_model.dart';
import 'package:chatapp/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = "/Profile";
  ProfileScreen({super.key});
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    // String uid = Get.arguments;
    UserModel userModel = Get.arguments;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(),
      body: FutureBuilder(
          future: Future.value(userModel),
          // future: ChatLogic.getUser(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text("no_user_found".tr),
              );
            }

            UserModel? user = snapshot.data;

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 295,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 220,
                          decoration: BoxDecoration(
                            color: MyMethods.bgColor2,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: isUserAndImgNotNull(user)
                              ? CachedImageFull(
                                  imageUrl: user!.photoUrl!,
                                  borderRadius: BorderRadius.circular(20),
                                  fit: BoxFit.fitWidth,
                                )
                              : const Center(
                                  child: Icon(Icons.image_rounded),
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Stack(
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: isUserAndImgNotNull(user)
                                      ? CachedImage(
                                          width: 150,
                                          height: 150,
                                          imageUrl: user!.photoUrl!,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        )
                                      : const Center(
                                          child: Icon(Icons.image_rounded),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Text("${user?.displayName}"),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text("${user?.email}"),
                ),
              ],
            );
          }),
    );
  }

  bool isUserAndImgNotNull(UserModel? user) {
    if (user != null && user.photoUrl != null) {
      return true;
    }
    return false;
  }
}
