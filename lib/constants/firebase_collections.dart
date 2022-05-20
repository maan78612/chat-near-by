import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class FBCollections {
  static CollectionReference notifications = db.collection("notifications");
  static CollectionReference users = db.collection("users");
  static CollectionReference chats = db.collection("chats");
  static CollectionReference chatRooms = db.collection("chatRooms");
}
