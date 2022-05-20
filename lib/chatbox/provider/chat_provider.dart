import 'dart:async';
import 'dart:io';

import 'package:chat_module/ModelClasses/userData.dart';
import 'package:chat_module/chatbox/models/chat_room.dart';
import 'package:chat_module/chatbox/models/message.dart';
import 'package:chat_module/chatbox/services/chat_services.dart';
import 'package:chat_module/chatbox/ui/conversation.dart';
import 'package:chat_module/utilities/show_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ChatProvider with ChangeNotifier {
  final ChatServices _services = CSs();
  final ScrollController listScrollController = ScrollController();
  bool isLoading = false;
   StreamSubscription? _chatSub;
  List<ChatRoom> chatRooms = [];
  // List<ChatRoom> readRooms = [];

  Stream<QuerySnapshot<Object?>> buildListStream(roomId) {
    return _services.buildConversationList(roomId: roomId);
  }

  Stream<QuerySnapshot> getUnreadMsgs({required String roomId}) {
    return _services.chatUnreadMessages(roomId);
  }

  //create Chat
  Future<void> initiateChat(UserData peerUser) async {
    startLoader();
    if (peerUser != null) {
      ChatRoom? isCreated = isAlreadyCreated(peerUser.email);
      if (isCreated != null) {
        if (kDebugMode) {
          print("room found======");
        }
        return Get.to(Conversation(
          room: isCreated,
          name: peerUser.firstName,
        ));
      } else {
        if (kDebugMode) {
          print("creating new======");
        }
        ChatRoom room = ChatRoom(
            unreadCount: 1,
            jobId: "",
            createdBy: AppUser.user.email,
            users: [AppUser.user.email, peerUser.email], roomId: "", createdAt: Timestamp.now());
        startLoader();
        ChatRoom cRoom = await _services.createChatRoom(room: room);
        stopLoader();
        Get.to(Conversation(
          room: cRoom,
          name: peerUser.email,
        ));
      }
    } else {
      ShowMessage.toast(
        "No people selected to add",
      );
    }
  }

  //check if already created chatroom
  ChatRoom? isAlreadyCreated(String email) {
    // check if chatRoom of these members already exits to avoid redundancy
    ChatRoom? room;
    List<ChatRoom> rooms = [];
    rooms.addAll(chatRooms);
    if (rooms.isEmpty) {
      room=null;
      return room;
    }
    for (int i = 0; i <= rooms.length ; i++) {
      ChatRoom element = rooms[i];
      if (element.users.contains(AppUser.user.email) &&
          element.users.contains(email)) {
        room = element;
        break;
      }
    }
    return room;
  }

  // Future<UserData> getUser(String email) async {
  //   //fetch user detail to show the name
  //
  //   UserData user = await fs.getUserById(email);
  //   return user;
  // }

  fetchMyChatRooms() async {
    //Loads all tasks that are assigned and are currently in progress
    try {
      startLoader();
      dynamic value = await _services.getAllChatRooms();
      stopLoader();
      /* if _chatSub is null which means stream is null*/
      _chatSub ??= value.listen((event) {
          chatRooms = event;
          chatRooms = chatRooms
              .where((element) => element.users.contains(AppUser.user.email))
              .toList();
          if (kDebugMode) {
            print("total rooms = ${chatRooms.length}");
          }
        });
      if (kDebugMode) {
        print("read List ${chatRooms.length}");
      }
      stopLoader();
    } catch (e) {
      stopLoader();
      ShowMessage.toast(
        e.toString(),
      );
    }
  }

  Future<String> uploadFile(File file) async {
    startLoader();
    String url = await _services.uploadFile(file: file);
    stopLoader();
    return url;
  }

  void sendMessage({required Message msg}) async {
    await _services.sendMessage(msg: msg);
  }

  Stream<QuerySnapshot> allUnreadMessages() {
    CollectionReference colRef = FirebaseFirestore.instance.collection("chats");
    Query query =
        colRef.where("receiver_id", isEqualTo: AppUser.user.email);
    query = query.where("seen", isEqualTo: false);
    // notifyListeners();

    return query.snapshots();
  }

  startLoader() {
    isLoading = true;
    notifyListeners();
  }

  stopLoader() {
    isLoading = false;
    notifyListeners();
  }

  void onDispose() {
    _chatSub?.cancel();
  }
}
