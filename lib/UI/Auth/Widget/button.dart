import 'package:chat_module/constants/app_constants.dart';
import 'package:chat_module/utilities/dimension.dart';
import 'package:chat_module/utilities/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget button(
    {required String title,
      required Color textColor,
      btnColor,
      required Function() onTab}) {
  return GestureDetector(
    onTap: onTab,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      margin: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeExtraLarge,
          vertical: Dimensions.paddingSmallSize),
      height: 43.h,
      decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            AppConfig.images.forwardIcon,
            scale: 5.h,
            color: AppConfig.colors.secondaryThemeColor,
          ),
          Text(
            title,
            style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeLarge, color: textColor),
          ),
          Image.asset(
            AppConfig.images.forwardIcon,
            scale: 5.h,
          )
        ],
      ),
    ),
  );
}