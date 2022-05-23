import 'package:chat_module/ModelClasses/userData.dart';
import 'package:chat_module/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/dimension.dart';
import '../../../utilities/styles.dart';

class ProfilePreview extends StatelessWidget {
  const ProfilePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: Hero(
              tag: 'profile-picture',
              child: ((AppUser.user.imageUrl) != "")
                  ? Container(
                      decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(AppUser.user.imageUrl),
                      ),
                    ))
                  : Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[100],
                        shape: BoxShape.rectangle,
                      ),
                      child: Center(
                          child: Text(
                        "No Image found",
                        textAlign: TextAlign.center,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: AppConfig.colors.whiteColor),
                      )),
                    )),
        ));
  }
}
