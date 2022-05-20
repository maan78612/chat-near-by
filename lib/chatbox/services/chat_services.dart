import 'dart:io';

import 'package:chat_module/ModelClasses/notification.dart';
import 'package:chat_module/ModelClasses/userData.dart';
import 'package:chat_module/chatbox/models/chat_room.dart';
import 'package:chat_module/chatbox/models/message.dart';
import 'package:chat_module/constants/firebase_collections.dart';
import 'package:chat_module/notificationBox/notification_sender.dart';
import 'package:chat_module/utilities/app_utility.dart';
import 'package:chat_module/utilities/firestorage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract class ChatServices {
  Future<void> sendMessage({required Message msg});
  Future<String> uploadFile({required File file});
  Stream<QuerySnapshot<Object?>> buildConversationList({required String roomId});
  Future<Stream<List<ChatRoom>>> getAllChatRooms();
  Stream<QuerySnapshot> chatUnreadMessages(String roomId);
  Future<ChatRoom> createChatRoom({required ChatRoom room});
  Future<ChatRoom> getChatRoomById({required String roomId});
  Future<UserData?> getUserById(String email);
}

class CSs implements ChatServices {
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Future<void> sendMessage({required Message msg}) async {
    FBNotification fbNotification = FBNotification();
    String timeStamp = DateTime.now().microsecondsSinceEpoch.toString();
    DocumentReference managerDocRef = FBCollections.chats.doc(timeStamp);
    msg.sentAt = Timestamp.now();
    var m = msg.toJson();
    db.runTransaction((transaction) async {
      transaction.set(
        managerDocRef,
        m,
      );
    });
    NotificationModal notif = NotificationModal(
        receiver: msg.receiverId,
        sender: AppUser.user.email,
        createdAt: Timestamp.now(),
        title: "",
        body: msg.msg);
    fbNotification.notify(notif, sendInApp: true, sendPush: true);
  }

  @override
  Future<String> uploadFile({required File  file}) async {
    String url = await FStorageServices().uploadSingleFile(
        bucketName: "chat media", file: file, userEmail: AppUser.user.email);
    return url;
  }

  // Future<String> getUserFCM({String userId}) async {
  //   DocumentSnapshot doc = await FBCollections.users.doc(userId).get();
  //   UserData user = UserData.fromJson(doc.data());
  //   return user.fcm;
  // }

  @override
  Stream<QuerySnapshot<Object?>> buildConversationList({required String roomId}) {
    Stream<QuerySnapshot<Object?>> messages = FBCollections.chats
        .where("room_id", isEqualTo: roomId)
        .orderBy('sent_at', descending: true)
        .snapshots();
    if (kDebugMode) {
      print("messages.first");
      print(messages.first);
    }

    return messages;
  }

  @override
  Future<Stream<List<ChatRoom>>> getAllChatRooms() async {
    Query query = FBCollections.chatRooms;

    query = query.orderBy("created_at", descending: true);
    var ref = query.snapshots().asBroadcastStream();
    var x = ref.map(
        (event) => event.docs.map((e) => ChatRoom.fromJson(e.data())).toList());
    return x;
  }

  @override
  Stream<QuerySnapshot> chatUnreadMessages(String roomId) {
    CollectionReference colRef = FBCollections.chats;
    Query query = colRef.where("room_id", isEqualTo: roomId);
    query = query
        .where("seen", isEqualTo: false)
        .where("receiver_id", isEqualTo: AppUser.user.email);
    return query.snapshots();
  }

  @override
  Future<ChatRoom> createChatRoom({required ChatRoom room}) async {
    String docId = AppUtility.getFreshTimeStamp();
    DocumentReference docRef = FBCollections.chatRooms.doc(docId);
    room.createdAt = Timestamp.now();
    room.roomId = docId;
    await db.runTransaction((trx) async => trx.set(docRef, room.toJson()));
    return getChatRoomById(roomId: docId);
  }

  @override
  Future<ChatRoom> getChatRoomById({required String roomId}) async {
    DocumentSnapshot doc = await FBCollections.chatRooms.doc(roomId).get();
    print(doc.data());
    return ChatRoom.fromJson(doc.data());
  }

  @override
  Future<UserData?> getUserById(String email) async {
    if (email == null || email.isEmpty) {
      return null;
    }
    DocumentSnapshot doc = await FBCollections.users.doc(email).get();
    if (!doc.exists) {
      return null;
    }
    UserData user = UserData.fromJson(doc.data());
    return user;
  }
}
