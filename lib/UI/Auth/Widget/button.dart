import 'package:chat_module/constants/app_constants.dart';
import 'package:chat_module/utilities/dimension.dart';
import 'package:chat_module/utilities/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget button(
    {required String title,
    required Color textColor,
    required bool isIcon,
    btnColor,
    required Function() onTab}) {
  return GestureDetector(
    onTap: onTab,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSmallSize),
      margin: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeExtraLarge,
          vertical: Dimensions.paddingSmallSize),
      height: 43.h,
      decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const Spacer(
          //   flex: 3,
          // ),
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                title,
                style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault, color: textColor),
              ),
            ),
          ),

          if (isIcon)
            Expanded(
              flex: 1,
              child: Image.asset(
                AppConfig.images.forwardIcon,
                scale: 5.h,
              ),
            ),
          // const Spacer( flex: 1),
        ],
      ),
    ),
  );
}
