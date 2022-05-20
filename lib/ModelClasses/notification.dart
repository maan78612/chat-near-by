import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModal {
  late String receiver;
  late String sender;
  late Timestamp createdAt;
  late String title;
  late String body;

  NotificationModal(
      {required this.receiver, required this.sender, required this.createdAt, required this.title, required this.body});

  NotificationModal.fromJson(dynamic json) {
    receiver = json["receiver"];
    sender = json["sender"];
    createdAt = json["created_at"];
    title = json["title"];
    body = json["body"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["receiver"] = receiver;
    map["sender"] = sender;
    map["created_at"] = createdAt;
    map["title"] = title;
    map["body"] = body;
    return map;
  }
}
