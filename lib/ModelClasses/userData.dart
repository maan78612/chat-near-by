

import 'package:chat_module/ModelClasses/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  late String imageUrl;
  late Timestamp createdAt;

  late String lastName;
  late String firstName;
  late String email;
  late double distanceToFindUser;
  late String fcm;
  late Location location;

  UserData(
      {required this.createdAt,
      required this.lastName,
      required this.firstName,
      required this.email,
      required this.distanceToFindUser,
      required this.fcm,
      required this.location,
      required this.imageUrl});

  UserData.fromJson(dynamic json) {

    imageUrl = json["image_url"];

    createdAt = json["created_at"];

    lastName = json["last_name"];
    firstName = json["first_name"];
    email = json["email"];
    fcm = json["fcm"];
    distanceToFindUser = double.parse(json["distance_to_find_user"].toString());
    location =
        (json["location"] != null ? Location.fromJson(json["location"]) : null)!;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    map["image_url"] = imageUrl;

    map["created_at"] = createdAt;

    map["last_name"] = lastName;
    map["first_name"] = firstName;
    map["email"] = email;
    map["fcm"] = fcm;
    map["distance_to_find_user"] = distanceToFindUser;
    map["location"] = location.toJson();
    return map;
  }
}


class AppUser {
  static late UserData user;
}
