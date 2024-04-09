// import 'package:chatapp/logic/MyMethods/my_methods.dart';
// import 'package:chatapp/logic/controllers/auth_controller.dart';
// import 'package:chatapp/logic/controllers/chats_controller.dart';
// import 'package:chatapp/logic/logic/home_logic.dart';
// import 'package:chatapp/logic/logic/logic.dart';
// import 'package:chatapp/logic/models/chat_model.dart';
// import 'package:chatapp/logic/models/msg_model.dart';
// import 'package:chatapp/views/new_chat_screen.dart';
// import 'package:chatapp/widgets/text_input.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../widgets/user_card.dart';

// class HomeScreen2 extends StatelessWidget {
//   static const String routeName = "/home2";
//   HomeScreen2({super.key});
//   final AuthController authController = Get.find();
//   final ChatsController chatsController = Get.put(ChatsController());
//   // final HomeController controller = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text("Home"),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: TextInput(
//                   label: "Search",
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//               ),
//             ),
//             PopupMenuButton(
//               color: MyMethods.bgColor2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               itemBuilder: (context) {
//                 return [
//                   PopupMenuItem(
//                     child: TextButton(
//                       onPressed: () {
//                         authController.signout();
//                       },
//                       child: const Text(
//                         "Profile",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   PopupMenuItem(
//                     child: TextButton(
//                       onPressed: () {
//                         authController.signout();
//                       },
//                       child: const Text(
//                         "Settings",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   PopupMenuItem(
//                     child: TextButton(
//                       onPressed: () {
//                         authController.signout();
//                       },
//                       child: const Text(
//                         "Sign Out",
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ),
//                   ),
//                 ];
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(width: 1, color: MyMethods.bgColor2),
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 child: CircleAvatar(
//                   backgroundColor: MyMethods.bgColor2,
//                   foregroundColor: MyMethods.bgColor2,
//                   radius: 20,
//                   backgroundImage: authController.user!.photoURL != null
//                       ? NetworkImage(authController.user!.photoURL!)
//                       : null,
//                   child: authController.user!.photoURL == null
//                       ? Text(authController.user!.email![0].toUpperCase())
//                       : null,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: StreamBuilder(
//         stream: HomeLogic.getChats(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData &&
//               snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text("No users"),
//             );
//           }
//           print(".....................................................");
//           print(snapshot.data!.docs);

//           return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, i) {
//                 final data = snapshot.data!.docs;
//                 ChatModel chatModel =
//                     ChatModel.fromJson(data[i].id, data[i].data());
//                 String? userId = chatModel.userId == authController.user?.uid
//                     ? chatModel.rUserId
//                     : chatModel.userId;

//                 return FutureBuilder(
//                   future: ChatLogic.getUser(userId!),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData &&
//                         snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     if (!snapshot.hasData || snapshot.data == null) {
//                       return const Center(
//                         child: Text("User not found"),
//                       );
//                     }

//                     return UserCard(
//                       userData: snapshot.data,
//                       authController: authController,
//                       lastMessage: StreamBuilder(
//                         stream: HomeLogic.getMessageById(
//                             authController.user!.uid,
//                             userId,
//                             chatModel.lastMessageId!),
//                         builder: (context, snapshot) {
//                           if (!snapshot.hasData &&
//                               snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                             return const Center(
//                               child: LinearProgressIndicator(),
//                             );
//                           }
//                           if (!snapshot.hasData ||
//                               snapshot.data == null ||
//                               snapshot.data!.data() == null) {
//                             return const SizedBox();
//                           }

//                           Msg? msg = Msg.fromJson(
//                               snapshot.data!.data() as Map<String, dynamic>);

//                           bool isCurrentUserMessage =
//                               msg.userId == authController.user!.uid;
//                           return Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Row(
//                                 children: [
//                                   if (isCurrentUserMessage) ...[
//                                     Icon(
//                                       msg.readAt != null
//                                           ? Icons.done_all_rounded
//                                           : Icons.done_all_rounded,
//                                       color: msg.readAt != null
//                                           ? MyMethods.blueColor2
//                                           : MyMethods.bgColor2,
//                                       size: 15,
//                                     ),
//                                     const SizedBox(width: 5),
//                                   ],
//                                   SizedBox(
//                                     width: Get.width * 0.5,
//                                     child: Text(
//                                       "Message: ${msg.message}",
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         color: Colors.grey.shade400,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   ChatLogic.getFormattedDate(msg.createdAt!),
//                                   style: TextStyle(
//                                     color: Colors.grey.shade400,
//                                     fontSize: 12,
//                                   ),
//                                   textAlign: TextAlign.end,
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 );
//               });
//         },
//       ),
//       floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: const Color.fromARGB(255, 49, 68, 97),
//         foregroundColor: Colors.white,
//         onPressed: () {
//           Get.toNamed(NewChatScreen.routeName);
//         },
//         // child: const Icon(Icons.chat),
//         label: const Text("Chat"),
//         icon: const Icon(Icons.chat),
//       ),
//     );
//   }
// }
