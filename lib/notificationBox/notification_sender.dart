import 'dart:convert';
import 'package:chat_module/ModelClasses/userData.dart';
import 'package:chat_module/chatbox/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../ModelClasses/notification.dart';
import '../constants/firebase_collections.dart';

class FBNotification {
  Future<void> notify(NotificationModal notification,
      {bool sendInApp = false, bool sendPush = false}) async {
    UserData? user = await CSs().getUserById(notification.receiver);
    notification.title = "${AppUser.user.firstName} ${AppUser.user.lastName}";
    if (sendInApp) {
      InAppNotifications.sendNotification(notification);
    }
    if (sendPush) {

      String? fcm = user?.fcm;
      if (kDebugMode) {
        print("fcm is $fcm");
      }
      PushNotification.sendNotification(fcm!, notification);
    }
  }
}

class InAppNotifications {
  static Future<void> sendNotification(NotificationModal notification) async {
    await FBCollections.notifications
        .doc(Timestamp.now().millisecondsSinceEpoch.toString())
        .set(notification.toJson())
        .then((value) {
      if (kDebugMode) {
        print('notification added');
      }
    });
  }
}

class PushNotification {
  static Future<void> sendNotification(
    String fcmToken,
    NotificationModal notification,
  ) async {
    Map<String, dynamic> notif = {
      'body': notification.body,
      'title': notification.title,
      // 'type': notification.type
    };
    String body = jsonEncode(
      <String, dynamic>{
        'notification': notif,
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '5',
          "sound": "default",
          'status': 'done'
        },
        'to': fcmToken,
      },
    );
    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAA5UqHUQg:APA91bErQ67c_3ghq2fOTwoUNU7GoSDh-MulZE-s_LQtinzLey57mjgYovED0pqipHT3SLINogFO1gi2EW2nlQJaqBMzgDBHV-jBhFniIfHR3UCs5mHbosUoEqq8bEnEOcVxFjoKoMtY',
            },
            body: body);
    if (kDebugMode) {
      print(body);
      print(response.statusCode);
      print(response.body);
    }

  }
}
