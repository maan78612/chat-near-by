import 'package:chat_module/ModelClasses/userData.dart';
import 'package:chat_module/chatbox/provider/chat_provider.dart';
import 'package:chat_module/chatbox/services/chat_services.dart';
import 'package:chat_module/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../Provider/auth.dart';

class HomeScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      return Scaffold(
        backgroundColor: AppConfig.colors.whiteColor,
        body: Center(
          child: Column(
            children: [
              const Text("Home"),
              Column(
                  children: List.generate(auth.nearByUser.length, (index) {
                UserData person = auth.nearByUser[index];
                return GestureDetector(
                    onTap: (){
                      startChat(person.email);
                    },
                    child: Text("${person.firstName} ${person.lastName}"));
              }))
            ],
          ),
        ),
      );
    });
  }

  startChat(String userID) async {
    var p = Provider.of<ChatProvider>(Get.context!, listen: false);
    await fetchUser(userID);
    await p.initiateChat(user!);
  }

  UserData? user;
  ChatServices _chatServices = CSs();

  fetchUser(String userID) async {
    user = await _chatServices.getUserById(userID);
    debugPrint("user found: ${user?.toJson()}");
  }
}
