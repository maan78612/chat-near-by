import 'package:chat_module/UI/dashBoard/dashBoardScreens/chat.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../UI/dashBoard/dashBoard.dart';

class LocalNotificationService {
  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    IOSInitializationSettings initializationSettingsIOS =
        const IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? id) async {
        if (kDebugMode) {
          print("onSelectNotification flutter local notification");
          print(id);
        }
        if (id!.isNotEmpty) {
          if (kDebugMode) {
            print("Router Value1234 $id");
          }

          Get.offAll(const DashBoard(1));
        }
      },
    );
  }

  static void createAndDisplayNotification(RemoteMessage message) async {
    /*
    2 thing happening here created channel and show heads up notification on foreground
    Heads up notification (snackBar) automatically show on background and termination state once channel created
    So there is no need to call that function on [getInitialMessage] termination and [onMessageOpenedApp] background
    */
    if (kDebugMode) {
      print("call: createAndDisplayNotification ");
    }
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: channel.importance,
            priority: Priority.high,
            playSound: true,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
          iOS: const IOSNotificationDetails(
            presentAlert: true,
            // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
            presentBadge: true,
            // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
            presentSound:
                true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
          ));
      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['_id'],
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Create a [AndroidNotificationChannel] for heads up notifications
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.max,
  );
}
