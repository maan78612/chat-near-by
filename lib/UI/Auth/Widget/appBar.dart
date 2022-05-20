


import 'package:chat_module/constants/app_constants.dart';
import 'package:chat_module/utilities/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

PreferredSize authAppBar() {
  return PreferredSize(
    preferredSize: Size.fromHeight(135.h),
    child: Center(
      child: Image.asset(
        AppConfig.images.logo,
        height: Responsive.isDesktop()? 125.h: 95.h,
      ),
    ),
  );
}