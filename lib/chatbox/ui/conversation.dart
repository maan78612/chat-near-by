import 'dart:async';
import 'dart:io';

import 'package:chat_module/ModelClasses/userData.dart';
import 'package:chat_module/chatbox/chat_enums.dart';
import 'package:chat_module/chatbox/models/chat_room.dart';
import 'package:chat_module/chatbox/models/message.dart';
import 'package:chat_module/chatbox/provider/chat_provider.dart';
import 'package:chat_module/chatbox/services/chat_services.dart';
import 'package:chat_module/constants/app_constants.dart';
import 'package:chat_module/constants/firebase_collections.dart';
import 'package:chat_module/utilities/dimension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Conversation extends StatefulWidget {
  final String name;
  final ChatRoom room;

  const Conversation({Key? key, required this.name, required this.room})
      : super(key: key);

  @override
  ConversationState createState() => ConversationState(room: room, name: name);
}

class ConversationState extends State<Conversation> {
  late String name;
  late ChatRoom room;

  ConversationState({required this.name, required this.room});

  TextEditingController msgCont = TextEditingController();
  final ChatServices _chatServices = CSs();
  late File image;
  late String receiverId = "";
  UserData? userData;
  late StreamSubscription<QuerySnapshot> streamSubscription;

  @override
  Widget build(BuildContext context) {
    // print(room.toJson());
    return Consumer<ChatProvider>(
        builder: (context, p, _) => Scaffold(
              appBar: AppBar(
                backgroundColor: AppConfig.colors.themeColor,
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios_outlined),
                ),
                title: Text(
                  'Conversation',
                  style: GoogleFonts.roboto(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              body: p.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      width: Get.width,
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /* this commented code need to be dom=ne if you want to show last seen*/
                          /* SizedBox(height: 20.h),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingExtraSmall),
                                width: 150.w,
                                height: 37.0.h,
                                padding:  EdgeInsets.all(Dimensions.paddingExtraSmall),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.16),
                                      offset: const Offset(0, 6.0),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 10.w),
                                    Container(
                                      width: 12.h,
                                      height: 12.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: AppConfig.colors.themeColor,
                                      ),
                                    ),
                                    SizedBox(width: Get.width * 0.08),
                                    TimeAgoWidget(
                                      withWatch: false,
                                      time: userData.onlineAt?.toDate() ??
                                          DateTime.now(),
                                    )
                                  ],
                                )),
                          ),*/
                          SizedBox(height: 20.h),
                          Expanded(child: buildListMessage(p)),
                          bottomTextFormField(p),
                        ],
                      ),
                    ),
            ));
  }

  Widget bottomTextFormField(ChatProvider p) {
    return Container(
      margin: EdgeInsets.only(
          bottom: Platform.isIOS ? Get.height * 0.03 : Get.height * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: AppConfig.colors.fillColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 5.0,
          ),
        ],
      ),
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textAlign: TextAlign.start,
              controller: msgCont,
              maxLines: null,
              onChanged: (val) {
                setState(() {});
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "type your message",
                hintStyle: const TextStyle(fontSize: 12, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                contentPadding: const EdgeInsets.all(0),
                fillColor: AppConfig.colors.fillColor,
                isDense: true,
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.bounceOut,
            switchOutCurve: Curves.bounceOut,
            child: p.isLoading
                ? const CircularProgressIndicator()
                : msgCont.text.isEmpty
                    ? mediaOptions(p)
                    : sendButton(p),
          )
        ],
      ),
    );
  }

  Widget mediaOptions(ChatProvider p) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _imgFromCamera(p);
              });
            },
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.camera_alt,
                color: Colors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _imgFromGallery(p);
              });
            },
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.photo_rounded,
                color: Colors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _fileFromPhone(p);
              });
            },
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.attach_file_sharp,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sendButton(ChatProvider p) {
    Message msg = Message(
        msg: msgCont.text,
        fileUrl: "",
        receiverId: receiverId,
        type: MessageTypeEnums.text,
        senderId: AppUser.user.email,
        roomId: room.roomId,
        seen: false,
        sentAt: Timestamp.now());

    return IconButton(
        icon: const Icon(Icons.send_rounded),
        onPressed: () {
          p.sendMessage(msg: msg);
          msgCont.clear();
        });
  }

  Widget buildListMessage(ChatProvider p) {
    return StreamBuilder(
      stream: p.buildListStream(room.roomId),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data!.docs.isEmpty) {
          // controller.onSendMessage(
          //     "Hi 👋", MessageTypeEnums.text, roomId);
          return const Center(
            child: Text("Send your first message"),
          );
        } else {
          // controller.listMessage = snapshot.data.docs;
          List<Message> msgs = [];
          for (var element in snapshot.data!.docs) {
            msgs.add(Message.fromJson(element.data()));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemBuilder: (context, index) =>
                buildMessageItem(index, msgs[index]),
            itemCount: snapshot.data!.docs.length,
            reverse: true,
            controller: p.listScrollController,
          );
        }
      },
    );
  }

  Widget buildMessageItem(int index, Message message) {
    int messageType = message.type;
    if (message.senderId == AppUser.user.email) {
      // Right (my message)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              messageType == MessageTypeEnums.text
                  ? textMessage(message, true)
                  : messageType == MessageTypeEnums.image
                      ? imageMessage(message, true)
                      : messageType == MessageTypeEnums.text
                          ? videoThumbnail(
                              message,
                            )
                          : messageType == MessageTypeEnums.file
                              ? fileMessage(message, true)
                              : Text(message.msg)
            ],
          ),
          // Align(
          //     alignment: Alignment.centerRight,
          //     child: messageTime(message, true)),
        ],
      );
    } else {
      // Left (peer message)
      return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                userAvatar(imageUrl: userData?.imageUrl),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          name.split(" ").first,
                          // style: MyTextStyles.montsSemiBold16,
                        ),
                        messageTime(message, false),
                      ],
                    ),
                    messageType == MessageTypeEnums.text
                        ? textMessage(message, false)
                        : messageType == MessageTypeEnums.image
                            ? imageMessage(message, false)
                            : messageType == MessageTypeEnums.video
                                ? videoThumbnail(message)
                                : messageType == MessageTypeEnums.file
                                    ? fileMessage(message, true)
                                    : Text(message.msg)
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget videoThumbnail(Message msg) {
    return const Text("media");
  }

  Widget textMessage(Message msg, bool isMyMessage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Get.width * 0.6),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      msg.msg,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    // (isMyMessage)
                    //     ? Icon(
                    //         Icons.check,
                    //         size: 35.w,
                    //         color: Colors.white,
                    //       )
                    //     : Container()
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget imageMessage(Message msg, bool isMyMessage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .7,
                  minWidth: 1),
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(msg.fileUrl)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget fileMessage(Message msg, bool isMyMessage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            _launchUrl(msg.fileUrl);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .7,
                    minWidth: 1),
                child: Container(
                    margin: const EdgeInsets.all(8.0),
                    child: const Text("Tab to open File !")),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _launchUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  Widget userAvatar({required String? imageUrl}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: (imageUrl ?? "") == ""
              ? AssetImage(
                  AppConfig.images.addImgIcon,
                )
              : NetworkImage(imageUrl!) as ImageProvider,
          maxRadius: Dimensions.radiusLarge,
          backgroundColor: Colors.transparent,
        ),
        SizedBox(width: Get.width * 0.04),
      ],
    );
  }

  Widget messageTime(Message msg, bool isMyMessage) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Row(
        children: [
          Text(
            DateFormat('hh:mm a').format(msg.sentAt.toDate()),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          // isMyMessage
          //     ? seenTick(document)
          //     : SizedBox(
          //   height: 0,
          // )
        ],
      ),
    );
  }

  ImagePicker picker = ImagePicker();

  _imgFromGallery(ChatProvider p) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      sendFile(image, p, MessageTypeEnums.image);
    }
  }

  _fileFromPhone(ChatProvider p) async {
    PlatformFile? pickedFile;

    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      pickedFile = result.files.first;
      final file = File(pickedFile.path!);
      sendFile(file, p, MessageTypeEnums.file);
    } else {
      return;
    }
  }

  _imgFromCamera(ChatProvider p) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      sendFile(image, p, MessageTypeEnums.image);
    }
  }

//send Media Message
  void sendFile(File chatFile, ChatProvider p, int msgType) async {
    String url = await p.uploadFile(chatFile);
    Message msg = Message(
        msg: "",
        fileUrl: url,
        receiverId: receiverId,
        type: msgType,
        senderId: AppUser.user.email,
        roomId: room.roomId,
        seen: false,
        sentAt: Timestamp.now());
    p.sendMessage(msg: msg);
  }

  Widget trailing = IconButton(
    icon: const Icon(
      Icons.more_vert,
      color: Colors.white,
      size: 18,
    ),
    onPressed: () {},
  );

// some functions to set seen true and fetch user details

  getUserData(String? id) async {
    ChatProvider p = Provider.of<ChatProvider>(context, listen: false);
    p.stopLoader();
    userData = (await _chatServices.getUserById(id!))!;
    if (kDebugMode) {
      print("user FOund : ${userData?.toJson()}");
    }
    p.stopLoader();
  }

  void readAllMessage() {
    streamSubscription = FBCollections.chats
        .where("room_id", isEqualTo: room.roomId)
        .where("sender_id", isEqualTo: userData?.email)
        .where("seen", isEqualTo: false)
        .snapshots()
        .listen((value) {
      for (var element in value.docs) {
        if (kDebugMode) {
          print(element.id);
        }
        FBCollections.chats
            .doc(element.id)
            .update({'seen': true}).then((value) {
          if (kDebugMode) {
            print('\nSeen : : : : updated\n');
          }
        });
      }
    });
  }

  setSeenTrue() {
    Future.delayed(const Duration(seconds: 2), () {
      readAllMessage();
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      receiverId =
          room.users.firstWhere((element) => element != AppUser.user.email);
      getUserData(receiverId);
      setSeenTrue();
      msgCont.addListener(() {
        if (msgCont.text.isEmpty) {
          setState(() {});
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }
}
