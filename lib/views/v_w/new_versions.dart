import 'package:chatapp/logic/MyMethods/my_methods.dart';
import 'package:chatapp/widgets/buttons/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future showVersionDialog() async {
  await Get.dialog(
    // const NewVersion(),
    const NewVersion(),
    // barrierDismissible: false,
  );
}

class NewVersion extends StatefulWidget {
  const NewVersion({super.key});

  @override
  State<NewVersion> createState() => _NewVersionState();
}

class _NewVersionState extends State<NewVersion> {
  bool isLoading = false;
  List<Map<String, dynamic>> versions = [];

  void getVersions() async {
    setState(() {
      isLoading = true;
    });
    final res = await FirebaseFirestore.instance
        .collection("versions")
        .orderBy("createdAt", descending: false)
        .get();
    List<Map<String, dynamic>> versionsRes =
        res.docs.map((e) => e.data()).toList();
    setState(() {
      versions = versionsRes;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getVersions();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Get.width / 15,
        vertical: Get.height / 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        // color: MyMethods.bgColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Scaffold(
          body: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : versions.isNotEmpty
                    ? ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    "assets/images/chat-logo.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "ChatApp",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: versions.length,
                            itemBuilder: (context, i) {
                              bool latest = versions.length - 1 == i;
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: MyMethods.bgColor2,
                                  border: Border.all(
                                    width: 0.5,
                                    color: versions[i]['works'] == true
                                        ? MyMethods.borderColor
                                        : const Color.fromARGB(
                                            141, 244, 67, 54),
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 15,
                                  ),
                                  leading: const CircleAvatar(
                                    backgroundColor: MyMethods.bgColor,
                                    backgroundImage: AssetImage(
                                      "assets/images/chat-logo.png",
                                    ),
                                  ),
                                  title: Text(
                                    "${"version".tr}: ${versions[i]['version']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: latest
                                      ? Text(
                                          "latest".tr,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      : null,
                                  trailing: PrimaryButton(
                                    borderRadius: BorderRadius.circular(50),
                                    text: "download".tr,
                                    onPressed: versions[i]['works'] == true
                                        ? () async {
                                            try {
                                              await launchUrlString(
                                                "${versions[i]['url']}",
                                              );
                                              Get.back();
                                            } catch (e) {
                                              print(e);
                                            }
                                          }
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : Text("no_versions".tr),
          ),
        ),
      ),
    );
  }
}

const String url = "https://mohammedaydan.github.io/Chat";

// class NewVersion extends StatelessWidget {
//   const NewVersion({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: Get.width,
//       height: Get.height,
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(30),
//         child: Column(
//           children: [
//             Expanded(
//               child: WebViewWidget(
//                 controller: WebViewController()
//                   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//                   ..setBackgroundColor(Colors.white)
//                   ..loadRequest(
//                     Uri.parse(url),
//                   )
//                   ..setNavigationDelegate(
//                     NavigationDelegate(
//                       onNavigationRequest: (request) async {
//                         if (request.url
//                             .startsWith("https://drive.google.com")) {
//                           await launchUrlString(request.url);
//                           return NavigationDecision.prevent;
//                         }
//                         return NavigationDecision.navigate;
//                       },
//                     ),
//                   ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
