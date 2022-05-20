
import 'package:chat_module/chatbox/ui/people_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../ModelClasses/userData.dart';
import '../models/chat_room.dart';
import '../provider/chat_provider.dart';
import '../services/chat_services.dart';
import '../widgets/emptyScreen.dart';
import '../widgets/shimmers/msg.dart';
import 'conversation.dart';

class DMs extends StatefulWidget {
  @override
  DMsState createState() => DMsState();
}

class DMsState extends State<DMs> {
  final ChatServices _chatServices = CSs();
  stopLoader(p) {
    //stops loader if working still in bg
    Future.delayed(const Duration(seconds: 1), () {
      p.stopLoader();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, p, _) {
      if (p.isLoading) {
        return const MsgShimmer();
      } else {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.03, horizontal: Get.width * 0.06),
            child: p.chatRooms.isEmpty
                ? const Center(
                    child: EmptyScreen(
                      message: "No DMs yet",
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      roomTile(p),
                      // readMessages(p),
                    ],
                  ),
          ),
        );
      }
    });
  }

  Widget roomTile(ChatProvider p) {
    return Column(
        children: List.generate(p.chatRooms.length, (index) {
      ChatRoom room = p.chatRooms[index];
      String userToSearch =
          room.users.where((element) => element != AppUser.user.email).first;
      return FutureBuilder(
          future: _chatServices.getUserById(userToSearch),
          builder: (context, AsyncSnapshot<UserData?> userSnap) {
            if (!userSnap.hasData) {
              return const MsgShimmerWidget();
            } else {
              return StreamBuilder(
                  stream: p.getUnreadMsgs(roomId: room.roomId),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
                    if (!snapShot.hasData) {
                      return const MsgShimmerWidget();
                    } else {
                      return PeopleTile(
                        img: userSnap.data!.imageUrl,
                        name: userSnap.data!.firstName,
                        onTap: () {
                          Get.to(Conversation(
                            name: userSnap.data!.firstName,
                            room: room,
                          ));
                        },
                        msgCount: snapShot.data?.docs.length ?? 0,
                      );
                    }
                  });
            }
          });
    }));
  }

  // Widget readMessages(ChatProvider p) {
  //   if (p.chatRooms.isEmpty) {
  //     return Container();
  //   } else {
  //     return Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Text(
  //               "Peoples",
  //               style: MyTextStyles.montsBold16.copyWith(
  //                   fontSize: 14,
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //             IconButton(icon: Icon(Icons.add), onPressed: () {}),
  //           ],
  //         ),
  //         SizedBox(height: Get.height * 0.02),
  //         Column(
  //             children: List.generate(p.chatRooms.length, (index) {
  //           ChatRoom room = p.chatRooms[index];
  //           String userToSearch = room.users
  //               .where((element) => element != AppUser.user.email)
  //               .first;
  //           return FutureBuilder(
  //               future: p.getUser(userToSearch),
  //               builder: (context, AsyncSnapshot<UserData> snapshot) {
  //                 if (!snapshot.hasData) {
  //                   return MsgShimmerWidget();
  //                 } else {
  //                   return PeopleTile(
  //                     name: snapshot.data.name,
  //                     onTap: () {
  //                       Get.to(Conversation(
  //                         name: snapshot.data.name,
  //                         room: room,
  //                       ));
  //                     },
  //                     msgCount: 3,
  //                   );
  //                 }
  //               });
  //         })),
  //         SizedBox(height: Get.height * 0.04),
  //       ],
  //     );
  //   }
  // }
}
