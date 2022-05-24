import 'dart:async';
import 'dart:convert';
import 'package:chat_module/notificationBox/message.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utilities/app_utility.dart';
import 'local_notification_service.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

// Crude counter to make messages unique
int _messageCount = 0;

/// The API endpoint here accepts a raw FCM payload for demonstration purposes.
String constructFCMPayload(String token) {
  _messageCount++;
  return jsonEncode({
    'token': token,
    'data': {
      'via': 'FlutterFire Cloud Messaging!!!',
      'count': _messageCount.toString(),
    },
    'notification': {
      'title': 'Hello FlutterFire!',
      'body': 'This notification (#$_messageCount) was created via FCM!',
    },
  });
}

/// Renders the example application.
class FBMessaging extends StatefulWidget {
  final Widget page;

  const FBMessaging({Key? key, required this.page}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Application();
}

class _Application extends State<FBMessaging> {
  late String _token;

  @override
  void didChangeDependencies() {
    onInit();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.page;
  }

  Future<void> onInit() async {
    await requestPermissions();
    await getFcmToken();
    LocalNotificationService.initialize(Get.context!);
    /* 1. This method call when app in terminated state and you get a notification
    when you click on notification app open from terminated state and you can get notification data in this method */

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (kDebugMode) {
          print(
              "FirebaseMessaging.instance.getInitialMessage [APP TERMINATED]");
        }

        if (message != null) {
          if (kDebugMode) {
            print("onInit msg when terminated: $message");
          }
          // Navigator.pushNamed(context, '/message',
          //     arguments: MessageArguments(message, true));
        }
      },
    );

    // 2. This method only call when App in foreground it mean app must be opened
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("FirebaseMessaging.onMessage [APP OPEN]");
      }
      LocalNotificationService.createAndDisplayNotification(message);
    });


    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("FirebaseMessaging.onMessage [APP CLOSE BUT NOT TERMINATED]");
      }
      // LocalNotificationService.createAndDisplayNotification(message);
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
    });
  }

  Future<void> requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
  }

  getFcmToken() {
    FirebaseMessaging.instance.getToken().then((token) {
      if (kDebugMode) {
        print("fcm =  $token");
      }
      AppUtility.freshFCM = token!;
    });
  }
}
