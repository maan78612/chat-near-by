import 'package:chat_module/chatbox/provider/chat_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../ModelClasses/userData.dart';
import '../../chatbox/services/chat_services.dart';

class MapProvider with ChangeNotifier {
  bool isLoading = false;

  void startLoader() {
    isLoading = true;
    if (kDebugMode) {
      print(isLoading);
    }
    notifyListeners();
  }

  void stopLoader() {
    isLoading = false;
    if (kDebugMode) {
      print(isLoading);
    }
    notifyListeners();
  }

  startChat(String userID) async {
    var p = Provider.of<ChatProvider>(Get.context!, listen: false);
    startLoader();
    try {
      await fetchUser(userID);
      await p.initiateChat(user);
      stopLoader();
    } on Exception catch (e) {
      if (kDebugMode) {
        print("error on starting chat is $e");
      }
      stopLoader();
    }
    notifyListeners();
  }

  UserData? user;
  final ChatServices _chatServices = CSs();

  fetchUser(String userID) async {
    user = await _chatServices.getUserById(userID);
    debugPrint("user found: ${user?.toJson()}");
  }
}
