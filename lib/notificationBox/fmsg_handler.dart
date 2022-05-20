import 'dart:async';
import 'dart:convert';
import 'package:chat_module/notificationBox/message.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../utilities/app_utility.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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

  Future<void> requestPermissions() async {

        await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
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

  void onInit() {
    requestPermissions();
    FirebaseMessaging.instance.getInitialMessage().then((dynamic message) {
      if (message != null) {
        if (kDebugMode) {
          print("onInit msg: $message");
        }
        // Navigator.pushNamed(context, '/message',
        //     arguments: MessageArguments(message, true));
      }
    });
    getFcmToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                playSound: true,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
      Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true));
    });
  }

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

  Future<void> sendPushMessage() async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token),
      );
      if (kDebugMode) {
        print('FCM request for device sent!');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.page;
  }
}

/// UI Widget for displaying metadata.
// class MetaCard extends StatelessWidget {
//   final String _title;
//   final Widget _children;
//
//   // ignore: public_member_api_docs
//   MetaCard(this._title, this._children);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         width: double.infinity,
//         margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
//         child: Card(
//             child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(children: [
//                   Container(
//                       margin: const EdgeInsets.only(bottom: 16),
//                       child:
//                           Text(_title, style: const TextStyle(fontSize: 18))),
//                   _children,
//                 ]))));
//   }
// }
