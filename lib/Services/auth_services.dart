
import 'package:chat_module/ModelClasses/userData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../constants/firebase_collections.dart';
import '../utilities/show_message.dart';

class AuthServices {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<String?> createUserWithEmailPassword(
      String email, String password) async {
    try {
      var user = (await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password))
          .user;

      return user?.uid;
    } catch (e) {
      if (kDebugMode) {
        print("I am Error \n\n\n $e");
      }
      return "0";
    }
  }

  static Future<User?> getCurrentUser() async {
    var user = _firebaseAuth.currentUser;
    return user;
  }

  static Future<User?> signInWithEmailPassword(
      String email, String password) async {
    if (kDebugMode) {
      print("i am sign in will provide UserId");
    }

    var user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password))
        .user;
    if (kDebugMode) {
      print("===================user id is ${user?.uid}============");
    }
    return user;
  }

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  static Future<void> sendResetPassEmail(String email) async {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      if (kDebugMode) {
        print("success");
      }
      ShowMessage.toast(
        "Password reset Link sent Successfully,\n Please check your mail box",
      );
    }).catchError((e) {
      String error = e.toString();
      if (kDebugMode) {
        print(error);
      }

      if (error.contains('USER_NOT_FOUND')) {
        ShowMessage.toast(
          'Email not registered',
        );
      } else {
        if (kDebugMode) {
          print(e.toString());
        }
        ShowMessage.toast(
          e.toString(),
        );
      }
    });
  }

  static Stream<List<UserData>> getAllUsers() {
    var ref = FBCollections.users.snapshots().asBroadcastStream();
    var x = ref.map((event) =>
        event.docs.map((e) => UserData.fromJson(e.data())).toList());
    return x;
  }
}