import 'package:chat_module/ModelClasses/userData.dart';
import 'package:chat_module/chatbox/provider/chat_provider.dart';
import 'package:chat_module/chatbox/services/chat_services.dart';
import 'package:chat_module/constants/app_constants.dart';
import 'package:chat_module/utilities/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../Provider/auth.dart';

class HomeScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      return Scaffold(
        backgroundColor: AppConfig.colors.whiteColor,
        body: ModalProgressHUD(
          inAsyncCall: auth.isLoading,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Home"),
                Column(
                    children: List.generate(auth.nearByUser.length, (index) {
                  UserData person = auth.nearByUser[index];
                  return GestureDetector(
                      onTap: (){
                        startChat(person.email);
                      },
                      child: Card(
                        margin: EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Padding(
                            padding:  EdgeInsets.all(Dimensions.paddingSizeDefault),
                            child: Text("${person.firstName} ${person.lastName}"),
                          )));
                }))
              ],
            ),
          ),
        ),
      );
    });
  }

  startChat(String userID) async {
    var p = Provider.of<ChatProvider>(Get.context!, listen: false);
    await fetchUser(userID);
    await p.initiateChat(user);
  }

  UserData? user;
  final ChatServices _chatServices = CSs();

  fetchUser(String userID) async {
    user = await _chatServices.getUserById(userID);
    debugPrint("user found: ${user?.toJson()}");
  }
}
