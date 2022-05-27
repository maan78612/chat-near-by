import 'package:chat_module/ModelClasses/userData.dart';
import 'package:chat_module/utilities/dimension.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_constants.dart';


class CustomDialogBox extends StatefulWidget {
  final UserData markerUser;

  const CustomDialogBox({required this.markerUser});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: dialog(context),
    );
  }



Widget dialog(BuildContext context) {
  return Center(
      child: Container(
        alignment: Alignment.center,
        width: 300.w,
        // height: 300.h,

        child: Card(
            elevation: 0,

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSmallSize,
                vertical: Dimensions.paddingSmallSize,
              ),
              child: contentBox(context),
            )),
      ));
}
  contentBox(context) {
    return Stack(
      alignment: Alignment.topCenter,

      clipBehavior: Clip.none,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 40.h,),
            Text(
              "${widget.markerUser.firstName} ${widget.markerUser.lastName}",
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              widget.markerUser.address,
              style: TextStyle(fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 22.h,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "yes",
                    style: TextStyle(fontSize: 18.sp),
                  )),
            ),
          ],
        ),
        Positioned(
          top: -40.h,
          child: CircleAvatar(
            backgroundImage: widget.markerUser.imageUrl != ""
                ? NetworkImage(widget.markerUser.imageUrl)
                : AssetImage(
              AppConfig.images.addImgIcon,
            ) as ImageProvider,
            radius: 40.h,
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}