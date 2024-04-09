import 'dart:io';

import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/my_app.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await _configureFirebase();
  await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  await FirebaseAnalytics.instance.logAppOpen();
  FirebaseRemoteConfig.instance.ensureInitialized();
  Gemini.init(apiKey: "AIzaSyCw_SHKlJGnYJZcnxBi0FFOhVe-KUinZqA");
  runApp(const MyApp());
}

Future _configureFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
      announcement: true,
    );
    initializationForFCM();
  }
}

void initializationForFCM() async {
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  List<String> topics = ['all', 'android', 'ios', 'web'];

  // Subscribe to 'all' topic by default
  await fcm.subscribeToTopic(topics[0]);
  await fcm.subscribeToTopic("update");
  await fcm.subscribeToTopic("TESTING");

  // Subscribe to platform-specific topics
  for (String topic in topics) {
    if (Platform.isAndroid && topic == 'android') {
      await fcm.subscribeToTopic(topic);
    } else if (Platform.isIOS && topic == 'ios') {
      await fcm.subscribeToTopic(topic);
    } else if (Platform.isMacOS && topic == 'web') {
      await fcm.subscribeToTopic(topic);
    }
  }
}
