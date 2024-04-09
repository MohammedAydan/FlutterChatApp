import 'package:chatapp/logic/controllers/chats_controller.dart';
import 'package:chatapp/logic/controllers/gemini_controller.dart';
import 'package:chatapp/logic/controllers/home_controller.dart';
import 'package:chatapp/views/ai/gemini_chat_screen.dart';
import 'package:chatapp/views/auth/register_screen.dart';
import 'package:chatapp/views/auth/signin_screen.dart';
import 'package:chatapp/views/chat/chat_group_screen.dart';
import 'package:chatapp/views/chat/chat_screen.dart';
import 'package:chatapp/views/create_group_screen.dart';
import 'package:chatapp/views/home/home_screen.dart';
import 'package:chatapp/views/home/home_screen3.dart';
import 'package:chatapp/views/main_screen.dart';
import 'package:chatapp/views/new_chat_screen.dart';
import 'package:chatapp/views/privacy/privacy_screen.dart';
import 'package:chatapp/views/profiles/my_profile_screen.dart';
import 'package:chatapp/views/profiles/profile_group_screen.dart';
import 'package:chatapp/views/profiles/profile_screen.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>> getPages = [
  GetPage(
    name: MainScreen.routeName,
    page: () => const MainScreen(),
  ),
  GetPage(
    name: SigninScreen.routeName,
    page: () => SigninScreen(),
  ),
  GetPage(
    name: RegisterScreen.routeName,
    page: () => RegisterScreen(),
  ),
  GetPage(
    name: HomeScreen.routeName,
    page: () => HomeScreen3(),
    binding: BindingsBuilder(() {
      Get.put(HomeController(), permanent: true);
      Get.put(ChatsController(), permanent: true);
    }),
  ),
  GetPage(
    name: ChatScreen.routeName,
    page: () => ChatScreen(),
  ),
  GetPage(
    name: ChatGroupScreen.routeName,
    page: () => ChatGroupScreen(),
  ),
  GetPage(
    name: NewChatScreen.routeName,
    page: () => NewChatScreen(),
  ),
  GetPage(
    name: MyProfileScreen.routeName,
    page: () => MyProfileScreen(),
  ),
  GetPage(
    name: ProfileScreen.routeName,
    page: () => ProfileScreen(),
  ),
  GetPage(
    name: CreateGroupScreen.routeName,
    page: () => CreateGroupScreen(),
  ),
  GetPage(
    name: ProfileGroupScreen.routeName,
    page: () => ProfileGroupScreen(),
  ),
  GetPage(
    name: GeminiChatScreen.routeName,
    page: () => GeminiChatScreen(),
    binding: BindingsBuilder.put(() => GeminiController(), permanent: true),
  ),
  GetPage(
    name: PrivacyScreen.routeName,
    page: () => const PrivacyScreen(),
  ),
];
