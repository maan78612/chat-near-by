import 'package:chat_module/utilities/show_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppUtility {
  static Transition pageTransition = Transition.leftToRightWithFade;
  static Duration transitionDuration = const Duration(milliseconds: 1000);
  static String msgErrorTitle = "Uh Oh!";
  static String msgSuccessTitle = "Success";
  static String myFcmToken = "";
  static String paymentTrxId = "", freshFCM = "";
  static String voiceNoteImage =
      "https://firebasestorage.googleapis.com/v0/b/books-exchange-48fa5.appspot.com/o/microphone.png?alt=media&token=081b0ad2-2621-4a9c-b1ce-9b497591ba7b";

  static void hideKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  static String getFreshTimeStamp() {
    return Timestamp.now().millisecondsSinceEpoch.toString();
  }

  // will pop function
  late DateTime currentBackPressTime;
   Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ShowMessage.toast( "press again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
}
