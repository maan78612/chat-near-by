import 'package:badges/badges.dart';
import 'package:chat_module/Provider/auth.dart';
import 'package:chat_module/UI/dashBoard/dashBoardScreens/homeScreen.dart';
import 'package:chat_module/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Services/auth_services.dart';
import '../../chatbox/provider/chat_provider.dart';
import '../../chatbox/ui/dms.dart';
import '../Auth/SignInView.dart';
import 'dashBoardScreens/Profile.dart';
import 'dashBoardScreens/chat.dart';
import 'dashBoardScreens/notification.dart';

class DashBoard extends StatefulWidget {
  final int _selectedIndex;
  const DashBoard(this._selectedIndex);
  @override
  _DashBoardState createState() => _DashBoardState(_selectedIndex);
}

class _DashBoardState extends State<DashBoard> {
  int _selectedIndex;
  _DashBoardState(this._selectedIndex);
  var scaffoldKey1 = GlobalKey<ScaffoldState>();

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer< AuthProvider>(
        builder: (context, auth, _) {
      return Scaffold(
        key: scaffoldKey1,
        backgroundColor: AppConfig.colors.whiteColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppConfig.colors.secondaryThemeColor,
          leading: GestureDetector(
            onTap: () {
              scaffoldKey1.currentState?.openDrawer();
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                AppConfig.images.drawerIcon,
                // color: Colors.white,
                scale: 4,
              ),
            ),
          ),
          title: Center(
            child: Text(
              _selectedIndex == 0
                  ? 'Home'
                  : _selectedIndex == 1
                      ? "Chat"
                      : _selectedIndex == 2
                          ? "Notifications"
                          : "Profile",
              style: const TextStyle(
                fontFamily: 'Bahnschrift',
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print("profile image");
                }
                _onItemTapped(3);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  AppConfig.images.personIcon,
                  color: Colors.white,
                  scale: 2,
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Container(
                height: Get.height * .3,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppConfig.colors.themeColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: auth.appUserData.imageUrl != null
                            ? NetworkImage(auth.appUserData.imageUrl)
                            : AssetImage(
                                AppConfig.images.addImgIcon,
                              ) as ImageProvider,
                        radius: Get.width * 0.1,
                        backgroundColor: Colors.transparent,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: Get.width * 0.4,
                            child: Text(
                                "${auth.appUserData.firstName} ${auth.appUserData.lastName}",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      color: AppConfig.colors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Get.width * .055),
                                )),
                          ),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: Get.width * 0.4),
                            child: Text(
                              auth.appUserData.email,
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      color: AppConfig.colors.whiteColor,
                                      fontSize: Get.width * .03)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: Get.height * .01,
                  ),
                    ],
                  ),
                ),
              ),
              Container(
                color: AppConfig.colors.whiteColor,
                height: Get.height * .68,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _drawerItem(0, "Home", AppConfig.images.home),
                    _drawerItem(1, "Notification", AppConfig.images.bell),
                    _drawerItem(2, "Chat Box", AppConfig.images.chat),
                    const Spacer(),
                    _signOutButton(auth)
                  ],
                ),
              )
            ],
          ),
        ),
        body: _getPage(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(AppConfig.images.home),
                    color: _selectedIndex == 0
                        ? AppConfig.colors.secondaryThemeColor
                        : AppConfig.colors.themeColor,
                  ),
                  label: 'Home',
                  backgroundColor: Color(0xffF4F2F2)),
              BottomNavigationBarItem(
                  icon: StreamBuilder(
                      stream: Provider.of<ChatProvider>(context, listen: false)
                          .allUnreadMessages(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                        if (!snap.hasData) {
                          return Badge(
                            badgeContent: const Text(""),
                            // borderRadius: BorderRadius.circular(5),
                            padding: EdgeInsets.zero,
                            shape: BadgeShape.circle,
                            position: const BadgePosition(top: -15, end: -10),
                            badgeColor: Colors.red,
                            child: ImageIcon(
                              AssetImage(AppConfig.images.chat),
                              color: _selectedIndex == 1
                                  ? AppConfig.colors.secondaryThemeColor
                                  : AppConfig.colors.themeColor,
                            ),
                          );
                        } else {
                          int count = snap.data!.docs.length;
                          return Badge(
                            badgeContent:
                                Text(count < 1 ? "" : count.toString()),
                            // borderRadius: BorderRadius.circular(5),
                            padding:
                                count < 1 ? EdgeInsets.zero : const EdgeInsets.all(4),
                            shape: BadgeShape.circle,
                            position: const BadgePosition(top: -15, end: -10),
                            badgeColor: Colors.red,
                            child: ImageIcon(
                              AssetImage(AppConfig.images.chat),
                              color: _selectedIndex == 1
                                  ? AppConfig.colors.secondaryThemeColor
                                  : AppConfig.colors.themeColor,
                            ),
                          );
                        }
                      }),
                  label: 'Chat',
                  backgroundColor: const Color(0xffF4F2F2)),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage(AppConfig.images.notification),
                  color: _selectedIndex == 2
                      ? AppConfig.colors.secondaryThemeColor
                      : AppConfig.colors.themeColor,
                ),
                label: "Notifications",
                backgroundColor: const Color(0xffF4F2F2),
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage(AppConfig.images.dashProfile),
                  color: _selectedIndex == 3
                      ? AppConfig.colors.secondaryThemeColor
                      : AppConfig.colors.themeColor,
                ),
                label: "Profile",
                backgroundColor: const Color(0xffF4F2F2),
              ),
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            selectedIconTheme: const IconThemeData(color: Colors.black),
            iconSize: 30,
            onTap: _onItemTapped,
            elevation: 5),
      );
    });
  }

  Widget _signOutButton(AuthProvider  auth) {
    return GestureDetector(
      onTap: () {
        Get.back();
        Get.bottomSheet(_areYouSureBottom(auth));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: Get.height * .01, horizontal: Get.width * .06),
        height: 45,
        width: Get.width,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            color: AppConfig.colors.whiteColor,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppConfig.images.signOutIcon,
              scale: 6,
            ),
            SizedBox(
              width: Get.width * .01,
            ),
            Text(
              "Sign Out",
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: Get.width * .032)),
            )
          ],
        ),
      ),
    );
  }

  Widget _areYouSureBottom(AuthProvider auth) {
    return Container(
        decoration: BoxDecoration(
            color: AppConfig.colors.whiteColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(26), topRight: Radius.circular(26))),
        height: Get.height * .35,
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * .05, vertical: Get.height * .02),
        child: Column(
          children: [
            Image.asset(
              AppConfig.images.sureIcon,
              scale: 5,
            ),
            Text(
              "Are You Sure?",
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: const Color(0xff355A6F),
                      fontSize: Get.width * .04,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: Get.height * .02,
            ),
            SizedBox(
              width: Get.width * .7,
              child: Text(
                "You want to logout.",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                  color: const Color(0xffB4B7BA),
                  fontSize: Get.width * .033,
                )),
              ),
            ),
            SizedBox(
              height: Get.height * .02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                yesNoButton(0, "NO", const Color(0xffEFF1F3),
                    AppConfig.colors.blackColor, const Color(0xffCACCCD), .44, auth),
                SizedBox(
                  width: Get.width * .03,
                ),
                yesNoButton(
                    1,
                    "YES",
                    AppConfig.colors.secondaryThemeColor,
                    AppConfig.colors.whiteColor,
                    AppConfig.colors.secondaryThemeColor,
                    .44,
                    auth),
              ],
            ),
          ],
        ));
  }

  Widget yesNoButton(int index, String title, Color color, textColor,
      borderColor, double width, AuthProvider auth) {
    return GestureDetector(
      onTap: () async {
        if (index == 1) {
          auth.clearSignInData();
          auth.onDispose();
          await AuthServices.signOut();
          Get.offAll(() => (SignInView()));
        } else {
          Get.back();
        }
      },
      child: Container(
        height: Get.height * 0.07,
        width: Get.width * .4,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: borderColor)),
        child: Center(
            child: Text(
          title,
          style: GoogleFonts.lato(
              textStyle: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: Get.width * .032)),
        )),
      ),
    );
  }

  Widget _drawerItem(int index, String title, img) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            {
              Get.back();
              Get.to(const DashBoard(0));

              break;
            }
          case 1:
            {
              Get.back();
              Get.offAll(const DashBoard(2));

              break;
            }
          case 2:
            {
              Get.back();
              Get.to(const DashBoard(1));
              break;
            }

        }
      },
      child: Container(
          color: AppConfig.colors.whiteColor,
          margin: EdgeInsets.symmetric(
              vertical: Get.height * .01, horizontal: Get.width * .06),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                        color: AppConfig.colors.whiteColor,
                        borderRadius: BorderRadius.circular(3)),
                    child: Image.asset(
                      img,
                      color: index == 1 ? null : AppConfig.colors.themeColor,
                      scale: 3,
                    ),
                  ),
                  SizedBox(
                    width: Get.width * .02,
                  ),
                  Text(
                    title,
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: AppConfig.colors.fieldTitleColor,
                            fontSize: Get.width * .035)),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xffAAB2BA),
                    size: 13,
                  )
                ],
              ),
              Divider(
                thickness: 1,
                color: const Color(0xff707070).withOpacity(.17),
              )
            ],
          )),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return  HomeScreen();
      case 1:
        return Chat();
      case 2:
        return NotificationApps();
      case 3:
        return Profile();

      default:
        return  HomeScreen();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
