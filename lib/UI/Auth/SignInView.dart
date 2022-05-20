import 'dart:io';

import 'package:chat_module/Provider/auth.dart';
import 'package:chat_module/UI/Auth/sign_up_view.dart';
import 'package:chat_module/UI/Shared/customTextField.dart';
import 'package:chat_module/constants/app_constants.dart';
import 'package:chat_module/utilities/app_utility.dart';
import 'package:chat_module/utilities/dimension.dart';
import 'package:chat_module/utilities/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../utilities/styles.dart';
import 'Widget/appBar.dart';
import 'Widget/button.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final GlobalKey<FormState> signInFromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: WillPopScope(
          onWillPop: AppUtility().onWillPop,
          child: Scaffold(
            //   resizeToAvoidBottomPadding: true,
            // resizeToAvoidBottomInset: false,

            backgroundColor: AppConfig.colors.themeColor,
            appBar: authAppBar(),
            body: ModalProgressHUD(
              inAsyncCall: auth.isLoading,
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      loginCard(auth),
                      signUpText(auth),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Container loginCard(AuthProvider auth) {
    return Container(
   // height: Responsive.isDesktop()?300.h:null,
   width: Responsive.isMobile()?null:170.w,
      padding: EdgeInsets.all(Dimensions.paddingSmallSize),
      margin: EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
          color: AppConfig.colors.whiteColor,
          borderRadius:
              BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge))),
      child: Column(
        children: [
          Text(
            "LOGIN",
            style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraLarge,
                color: AppConfig.colors.themeColor),
          ),
          SizedBox(
            height: 10.h,
          ),
          Form(
            key: signInFromKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                GlobalFormField(
                  index: 1,
                  hint: "User Email",
                  title: "Email",
                  titleColor: AppConfig.colors.fieldTitleColor,
                  prefixIcon: AppConfig.images.mailIcon,
                  controller: auth.loginEmailController,
                  focusNode: auth.loginEmailFocusNode,
                  nextNode: auth.loginPassFocusNode,
                  type: TextInputType.text,
                  action: TextInputAction.next,
                  textLimit: 50,
                  validator: FieldValidator.validateEmail,
                  isPassword: false,
                  isEmail: true,
                ),
                GlobalFormField(
                  index: 1,
                  hint: "Please enter your password",
                  title: "Password",
                  titleColor: AppConfig.colors.fieldTitleColor,
                  prefixIcon: AppConfig.images.lockIcon,
                  controller: auth.loginPassController,
                  focusNode: auth.loginPassFocusNode,
                  type: TextInputType.text,
                  action: TextInputAction.done,
                  textLimit: 25,
                  validator: FieldValidator.validatePasswordSignup,
                  isPassword: true,
                  nextNode: FocusNode(),
                  isEmail: false,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Get.bottomSheet(ForgotPasswordDialog());
            },
            child: Padding(
              padding: EdgeInsets.only(
                  right: Dimensions.paddingExtraSmall,
                  top: Dimensions.paddingExtraSmall,
                  bottom: Dimensions.paddingExtraSmall),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password ?",
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: AppConfig.colors.blackGrey),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.paddingSmallSize),
            child: button(
                btnColor: AppConfig.colors.secondaryThemeColor,
                textColor: AppConfig.colors.whiteColor,
                title: "LOG IN",
                onTab: () {
                  if (signInFromKey.currentState!.validate()) {
                    auth.loginUser();
                  }
                }),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  RichText signUpText(AuthProvider auth) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Don\'t have account ? Sign up ',
            style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: AppConfig.colors.whiteColor),
          ),
          TextSpan(
              text: 'here',
              style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: AppConfig.colors.blackGrey,
                  decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  auth.userImage = null;
                  Get.off(SignUpView(
                    isProfile: false,
                    appBarTitle: "Sign Up",
                  ));
                }),
        ],
      ),
    );
  }


}
