import 'dart:async';

import 'package:chat_module/UI/Shared/customTextField.dart';
import 'package:chat_module/constants/app_constants.dart';
import 'package:chat_module/utilities/show_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:provider/provider.dart';

import '../../Provider/auth.dart';
import '../../utilities/app_utility.dart';
import '../../utilities/dimension.dart';
import '../../utilities/styles.dart';
import '../../utilities/validator.dart';
import 'SignInView.dart';
import 'Widget/appBar.dart';
import 'Widget/button.dart';

class SignUpView extends StatefulWidget {
  String appBarTitle;
  bool isProfile;

  SignUpView({Key? key, required this.isProfile, required this.appBarTitle})
      : super(key: key);

  @override
  SignUpViewState createState() =>
      SignUpViewState(appBarTitle: appBarTitle, isProfile: isProfile);
}

class SignUpViewState extends State<SignUpView> {
  final signUpFormKey1 = GlobalKey<FormState>();

  String appBarTitle;
  bool isProfile;

  SignUpViewState({required this.isProfile, required this.appBarTitle});

  @override
  void initState() {
    if (kDebugMode) {
      print(
          " here ${Provider.of<AuthProvider>(context, listen: false).userImage}");
    }
    var auth = Provider.of<AuthProvider>(context, listen: false);
    if (isProfile) {
      auth.firstNameController.text = auth.appUserData.firstName;
      auth.lastNameController.text = auth.appUserData.lastName;
      auth.emailController.text = auth.appUserData.email;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, model, _) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          model.matchPassProvider(8, model.passwordController.text.toString());
        },
        child: WillPopScope(
          onWillPop: AppUtility().onWillPop,
          child: Scaffold(
            backgroundColor: AppConfig.colors.themeColor,
            appBar: authAppBar(),
            body: ModalProgressHUD(
              inAsyncCall: model.isLoading,
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: [signUpCard(model),!isProfile? signInText(model):const SizedBox()],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Container signUpCard(AuthProvider model) {
    return Container(
      width: Responsive.isMobile() ? null : 150.w,
      padding: EdgeInsets.all(Dimensions.paddingSmallSize),
      margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSmallSize),
      decoration: BoxDecoration(
          color: AppConfig.colors.whiteColor,
          borderRadius:
              BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge))),
      child: Column(
        children: [
          Text(
            isProfile ? "Edit Profile" : "SIGN UP",
            style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraLarge,
                color: AppConfig.colors.themeColor),
          ),
          SizedBox(
            height: 10.h,
          ),
          _topAddImageCard(model),
          signUpForm(model),
          if (!isProfile) _termsConditions(1, model),
          button(
              btnColor: AppConfig.colors.secondaryThemeColor,
              textColor: AppConfig.colors.whiteColor,
              title: isProfile ? "EDIT" : "SIGN UP",
              onTab: () {
                if (isProfile == false) {
                  model.register(signUpFormKey1);
                } else {
                  model.pressEdit(signUpFormKey1);
                }
              }),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Form signUpForm(AuthProvider model) {
    return Form(
      key: signUpFormKey1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          GlobalFormField(
            index: 2,
            hint: "Enter First Name",
            title: "First Name",
            titleColor: AppConfig.colors.fieldTitleColor,
            prefixIcon: AppConfig.images.personIcon,
            controller: model.firstNameController,
            focusNode: model.firstNameFocusNode,
            nextNode: model.lastNameFocusNode,
            type: TextInputType.text,
            action: TextInputAction.next,
            textLimit: 25,
            validator: FieldValidator.validateFullName,
            isPassword: false,
            isEmail: false,
          ),
          GlobalFormField(
            index: 3,
            hint: "Enter Last Name",
            title: "Last Name",
            titleColor: AppConfig.colors.fieldTitleColor,
            prefixIcon: AppConfig.images.personIcon,
            controller: model.lastNameController,
            focusNode: model.lastNameFocusNode,
            nextNode: model.emailFocusNode,
            type: TextInputType.text,
            action: TextInputAction.next,
            textLimit: 25,
            validator: FieldValidator.validateFullName,
            isPassword: false,
            isEmail: false,
          ),
          if (!isProfile)
            GlobalFormField(
              index: 6,
              isEmail: true,
              hint: "Please enter your registered email",
              title: "Email",
              titleColor: AppConfig.colors.fieldTitleColor,
              prefixIcon: AppConfig.images.mailIcon,
              controller: model.emailController,
              focusNode: model.emailFocusNode,
              nextNode: model.passwordFocusNode,
              type: TextInputType.text,
              action: TextInputAction.next,
              textLimit: 30,
              validator: FieldValidator.validateEmail,
              isPassword: false,
            ),
          if (!isProfile)
            GlobalFormField(
              isPassword: true,
              title: "Password",
              index: 7,
              hint: "Please enter your password",
              titleColor: AppConfig.colors.fieldTitleColor,
              prefixIcon: AppConfig.images.lockIcon,
              controller: model.passwordController,
              focusNode: model.passwordFocusNode,
              nextNode: model.confirmPasswordFocusNode,
              type: TextInputType.text,
              action: TextInputAction.next,
              textLimit: 25,
              validator: FieldValidator.validatePasswordSignup,
              isEmail: false,
            ),
          if (!isProfile)
            GlobalFormField(
              isPassword: true,
              title: "Confirm Password",
              index: 8,
              hint: "Confirm your password",
              titleColor: AppConfig.colors.fieldTitleColor,
              prefixIcon: AppConfig.images.lockIcon,
              controller: model.confirmPasswordController,
              focusNode: model.confirmPasswordFocusNode,
              type: TextInputType.text,
              action: TextInputAction.done,
              textLimit: 25,
              validator: FieldValidator.validateConfirmPasswordSignup,
              nextNode: FocusNode(),
              isEmail: false,
            ),
        ],
      ),
    );
  }

  Widget signInText(AuthProvider auth) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Existing User? ',
              style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: AppConfig.colors.whiteColor),
            ),
            TextSpan(
                text: 'Login',
                style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: AppConfig.colors.blackGrey,
                    decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    auth.clearSignUpData();
                    Get.off(SignInView());
                  }),
          ],
        ),
      ),
    );
  }

  Widget _termsConditions(int index, AuthProvider model) {
    return Padding(
      padding: EdgeInsets.only(left: Responsive.isMobile()?10.w:5.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              model.selectTermToggle();
            },
            child: Container(
              height: 18.h,
              width: 18.h,
              decoration: BoxDecoration(
                color: AppConfig.colors.fillColor,
                border: Border.all(color: AppConfig.colors.fieldBorderColor),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Icon(
                Icons.check,
                color: model.selectTerms
                    ? AppConfig.colors.themeColor
                    : AppConfig.colors.fillColor,
                size: 13.sp,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              ShowMessage.toast("Terms & Conditions");
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.h, horizontal:Responsive.isMobile()?10.w:5.w),
              child: RichText(
                text: TextSpan(
                  text: "I agree with ",
                  style: robotoMedium.copyWith(
                      fontSize: Responsive.isMobile()?Dimensions.fontSizeDefault:Dimensions.fontSizeSmall,
                      color: AppConfig.colors.blackColor),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Terms & Conditions ",
                      style: robotoMedium.copyWith(
                          fontSize: Responsive.isMobile()?Dimensions.fontSizeDefault:Dimensions.fontSizeSmall,
                          color: AppConfig.colors.blackColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topAddImageCard(AuthProvider auth) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        margin: EdgeInsets.symmetric(horizontal: 25.w),
        decoration: BoxDecoration(
            color: AppConfig.colors.whiteColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 3,
                  blurRadius: 2,
                  color: AppConfig.colors.blackColor.withOpacity(.06))
            ]),
        child: Column(
          children: [
            Text(
              isProfile ? "Update your Profile Picture" : "Add image",
              style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: AppConfig.colors.blackColor),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 10.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        (Provider.of<AuthProvider>(context, listen: false)
                                    .userImage !=
                                null)
                            ? FileImage(auth.userImage!)
                            : (isProfile == true && auth.appUserData.imageUrl != "")
                                ? NetworkImage(auth.appUserData.imageUrl)
                                : AssetImage(
                                    AppConfig.images.addImgIcon,
                                  ) as ImageProvider,
                    radius: 50.0.h,
                    backgroundColor: Colors.transparent,
                  ),
                  Positioned(
                    bottom: 5.h,
                    right: 5.w,
                    child: GestureDetector(
                      onTap: () {
                        auth.getImage();
                      },
                      child: Container(
                        padding: EdgeInsets.all(Dimensions.paddingExtraSmall),
                        decoration: BoxDecoration(
                          color: AppConfig.colors.themeColor,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.camera_alt,
                          size: 10.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

// successfully sign up bottom sheet

class SuccessfullySignUpBottom extends StatefulWidget {
  @override
  _SuccessfullySignUpBottomState createState() =>
      _SuccessfullySignUpBottomState();
}

class _SuccessfullySignUpBottomState extends State<SuccessfullySignUpBottom> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Provider.of<AuthProvider>(Get.context!, listen: false).clearSignUpData();

      Get.offAll(() => SignInView());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppConfig.colors.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radiusDefault),
                topRight: Radius.circular(Dimensions.radiusDefault))),
        height: 50.h,
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSmallSize),
        child: Column(
          children: [
            Image.asset(
              AppConfig.images.checkIcon,
              scale: 5.h,
            ),
            Text(
              "Congratulations",
              style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: AppConfig.colors.themeColor,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              width: 200.w,
              child: Text(
                "Sign up has been successful. Now redirecting you to login page",
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: AppConfig.colors.themeColor,
                ),
              ),
            ),
          ],
        ));
  }
}
