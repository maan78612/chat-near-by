import 'package:chat_module/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Provider/auth.dart';
import '../../Auth/sign_up_view.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      return Scaffold(
        backgroundColor: AppConfig.colors.whiteColor,
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(
                  left: Get.width * .05,
                  right: Get.width * .05,
                  top: Get.width * .03),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage:  auth.appUserData.imageUrl != ""
                        ? NetworkImage(auth.appUserData.imageUrl)
                        : AssetImage(
                      AppConfig.images.addImgIcon,
                    ) as ImageProvider,
                    radius: Get.width * 0.15,
                    backgroundColor: Colors.transparent,
                  ),
                  profileData("First Name", auth.appUserData.firstName),
                  profileData("last Name", auth.appUserData.lastName),
                  SizedBox(height: Get.height * 0.01),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Distance to find users by 50 miles : ",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: Get.width * .04,
                              fontWeight: FontWeight.bold,
                              color: AppConfig.colors.blackGrey)),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.01),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppConfig.colors.themeColor,
                      inactiveTrackColor: AppConfig.colors.fieldBorderColor,
                      trackShape: const RoundedRectSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      thumbColor: AppConfig.colors.themeColor,
                      overlayColor: AppConfig.colors.enableBorderColor,
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 28.0),
                      tickMarkShape: const RoundSliderTickMarkShape(),
                      activeTickMarkColor: AppConfig.colors.themeColor,
                      inactiveTickMarkColor: AppConfig.colors.fieldBorderColor,
                      valueIndicatorShape:
                          const PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: AppConfig.colors.themeColor,
                      valueIndicatorTextStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Slider(
                      value: auth.appUserData.distanceToFindUser,
                      min: 0,
                      max: 50,
                      divisions: 50,
                      label: '${auth.appUserData.distanceToFindUser}',
                      onChangeEnd: (value) {
                        auth.fetchAllUsers();

                      },
                      onChanged: (value) async {
                        await auth.setDistance(value);
                      },
                    ),
                  ),
                ],
              )),
        ),
        bottomNavigationBar: editButton(auth),
      );
    });
  }

  Widget editButton(AuthProvider auth) {
    return GestureDetector(
      onTap: () {
        auth.userImage;
        Get.to(SignUpView(
          appBarTitle: " Profile",
          isProfile: true,
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width * .03),
        margin: EdgeInsets.symmetric(
            horizontal: Get.width * .15, vertical: Get.height * .02),
        height: 55,
        width: Get.width * .8,
        decoration: BoxDecoration(
            color: AppConfig.colors.secondaryThemeColor,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Edit",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Get.width * .045),
                )),
          ],
        ),
      ),
    );
  }

  Widget profileData(String title, String data) {
    return Card(
      elevation: 5,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: Get.height * 0.025, horizontal: Get.width * 0.02),
        decoration: BoxDecoration(
          color: AppConfig.colors.themeColor.withOpacity(0.5),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                "$title : ",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: Get.width * .05,
                        fontWeight: FontWeight.bold,
                        color: AppConfig.colors.blackGrey)),
              ),
            ),
            Container(
              width: Get.width * 0.39,
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                data,
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: Get.width * .045,
                        fontWeight: FontWeight.bold,
                        color: AppConfig.colors.whiteColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
