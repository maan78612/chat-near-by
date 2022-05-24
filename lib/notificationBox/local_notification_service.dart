import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class LocalNotificationService {
  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {

    // _notificationsPlugin.resolvePlatformSpecificImplementation<
    // AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);

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
        }
        if (id!.isNotEmpty) {
          if (kDebugMode) {
            print("Router Value1234 $id");
          }

          /*    Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DemoScreen(
                id: id,
              ),
            ),
          );*/
        }
      },
    );
  }




  static void createAndDisplayNotification(RemoteMessage message) async {

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
          iOS:  const IOSNotificationDetails(
            presentAlert: true,  // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
            presentBadge: true,  // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
            presentSound: true,  // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)

          )
      );
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
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
}
