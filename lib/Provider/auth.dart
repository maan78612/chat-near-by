import 'dart:async';
import 'dart:io';

import 'package:chat_module/ModelClasses/userData.dart';
import 'package:chat_module/UI/Shared/image_media.dart';
import 'package:chat_module/mapsBox/widgets/addMarker.dart';
import 'package:chat_module/utilities/firestorage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../ModelClasses/location.dart';
import '../Services/auth_services.dart';
import '../UI/Auth/SignInView.dart';
import '../UI/dashBoard/dashBoard.dart';
import '../chatbox/provider/chat_provider.dart';
import '../constants/app_constants.dart';
import '../constants/firebase_collections.dart';
import '../utilities/app_utility.dart';
import '../utilities/location_service.dart';
import '../utilities/show_message.dart';
import '../utilities/validator.dart';

class AuthProvider extends ChangeNotifier {
  FStorageServices fStorage = FStorageServices();
  late UserData appUserData;

  //////////////////////Login Sign Up/////////////////////////

  ///////////loading////////////
  bool isLoading = false;

  String app = "From app";

  ///////////login variables////////////
  bool passVisible = false;

  ///////////signUp variables////////////
  var isAcceptedConfirmPWDProvider = -1;
  var isAcceptedPWDProvider = -1;
  var isAcceptedEmail = -1;

  bool passVisibleSignUp = false;
  bool passVisibleSignUp2 = false;
  bool selectTerms = false;
  File? userImage;

  final PageController signUpPageController = PageController();

  ///////////login Controllers////////////
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPassController = TextEditingController();

  ///////////SignUp Controllers////////////
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController schoolController = TextEditingController();
  TextEditingController majorController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ///////////login focus node////////////
  FocusNode loginPassFocusNode = FocusNode();
  FocusNode loginEmailFocusNode = FocusNode();

  ///////////SignUp focus node////////////
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  String imageUrlToSet = '';

  void startLoader() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoader() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> matchPassProvider(int index, String value) async {
    if (FieldValidator.validateConfirmPassword(value) ==
        "Confirm Password is Required") {
      isAcceptedConfirmPWDProvider = -1;
    } else if (passwordController.value.text.toString() ==
        confirmPasswordController.value.text.toString()) {
      isAcceptedConfirmPWDProvider = 1;
    } else {
      isAcceptedConfirmPWDProvider = 0;
    }

    notifyListeners();
  }

  Future register(GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      matchPassProvider(8, passwordController.value.text.toString());

      if (passwordController.value.text.toString() !=
          confirmPasswordController.value.text.toString()) {
        Fluttertoast.showToast(
            msg: 'Password does not match', backgroundColor: Colors.red);
      } else if (selectTerms == false) {
        Fluttertoast.showToast(msg: 'Please accept the terms & conditions');
      } else {
        await registerUser();
      }
    } else {
      if (kDebugMode) {
        print("1111111111");
      }
    }
    notifyListeners();
  }

  pressSave(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      updateUserInDB(userImage);
      notifyListeners();
    }
  }

  clearSignInData() {
    loginEmailController.clear();
    loginPassController.clear();

    notifyListeners();
  }

  clearSignUpData() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    schoolController.clear();
    majorController.clear();
    jobController.clear();
    subjectController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    imageUrlToSet = '';
    isAcceptedPWDProvider = -1;
    isAcceptedConfirmPWDProvider = -1;
    isAcceptedEmail = -1;
    userImage = null;
    selectTerms = false;

    notifyListeners();
  }

  selectTermToggle() {
    selectTerms = !selectTerms;
    notifyListeners();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////BACKEND/////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////SIGN UP///////////////////////////

  ChatProvider p = Provider.of<ChatProvider>(Get.context!, listen: false);

  Future getImageFunc() async {
    File? pickedFile = await Get.bottomSheet(ImageOptionSheet());
    if (pickedFile != null) {
      userImage = File(pickedFile.path);
    } else {
      if (kDebugMode) {
        print("not added");
      }
    }

    notifyListeners();
  }

  Future<void> matchEmail(int index, String value) async {
    if (FieldValidator.validateEmail(value) ==
        "Please enter a valid Email Address") {
      isAcceptedEmail = 0;
    } else if (FieldValidator.validateEmail(value) == "Email is Required") {
      isAcceptedEmail = -1;
    } else {
      isAcceptedEmail = 1;
    }

    print("here $isAcceptedEmail");

    notifyListeners();
  }

  Future<void> registerUser() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode()); // close keyboard
    startLoader();
    DocumentSnapshot userDocument =
        await FBCollections.users.doc(emailController.text.trim()).get();
    stopLoader();
    if (userDocument.exists) {
      if (kDebugMode) {
        print("user exist");
      }
      ShowMessage.snackBar("Oops!", "User already exists", false);
    } else {
      startLoader();
      if (kDebugMode) {
        print("user not exist");
      }
      AuthServices.createUserWithEmailPassword(
              emailController.text.trim(), passwordController.text.trim())
          .then((value) async {
        if (kDebugMode) {
          print(value);
        }
        createUserInDB(userImage, emailController.text.trim());
      });
    }
  }

  void createUserInDB(File? imageFile, String email) async {
    print("image file is $imageFile");
    imageUrlToSet = "";
    startLoader();
    if (imageFile != null) {
      imageUrlToSet = await fStorage.uploadSingleFile(
          bucketName: "Profile Images", file: imageFile, userEmail: email);
    }

    startLoader();
    String address =
    await _loc.getAddressFromLatLong(currentLocation);
    FBCollections.users
        .doc(emailController.text)
        .set(UserData(
          createdAt: Timestamp.now(),
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          imageUrl: imageUrlToSet,
          location: currentLocation,
          distanceToFindUser: 50,
          fcm: '', address: address,
        ).toJson())
        .then((value) async {
      appUserData = (await getUserFromDB(emailController.text))!;

      clearSignUpData();

      await fetchAllUsers();
      stopLoader();
      Get.offAll(() => const DashBoard(0));
      // Get.bottomSheet(SuccessfullySignUpBottom(),
      //     isDismissible: false, enableDrag: false);
    });
  }

  void updateUserInDB(File? imageFile) async {
    imageUrlToSet = "";
    startLoader();
    if (imageFile != null) {
      imageUrlToSet = await fStorage.uploadSingleFile(
          bucketName: "Profile Images",
          file: imageFile,
          userEmail: appUserData.email);
    } else {
      imageUrlToSet = appUserData.imageUrl;
    }
    String address =
        await _loc.getAddressFromLatLong(appUserData.location);
    FBCollections.users
        .doc(emailController.text)
        .update(UserData(
                createdAt: Timestamp.now(),
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                imageUrl: imageUrlToSet,
                distanceToFindUser: appUserData.distanceToFindUser,
                email: appUserData.email,
                location: appUserData.location,
                fcm: appUserData.fcm, address: address)
            .toJson())
        .then((value) async {
      appUserData = (await getUserFromDB(appUserData.email))!;
      AppUser.user = appUserData;
      stopLoader();
      clearSignUpData();
      Get.back();
    });
  }

  void updateFCM(String fcm) async {
    FBCollections.users.doc(AppUser.user.email).update({"fcm": fcm});
  }

  Future<UserData?> getUserFromDB(String email) async {
    if (kDebugMode) {
      print("email $email");
    }
    startLoader();
    DocumentSnapshot doc = await FBCollections.users.doc(email).get();
    stopLoader();
    if (!doc.exists) {
      return null;
    }
    UserData user = UserData.fromJson(doc.data());
    AppUser.user = user;
    return user;
  }

/////////////////////////LOG IN///////////////////////////

  Future<void> autoLogin() async {
    startLoader();

    await fetchCurrentLatLng();
    User? user = await AuthServices.getCurrentUser();
    if (kDebugMode) {
      print("$user");
    }
    if (user != null) {
      if (kDebugMode) {
        print("not null");
        print("user login");
      }

      handleSignIn(user.email!);
      stopLoader();
    } else {
      stopLoader();
      Get.off(() => SignInView());
    }
    notifyListeners();
  }

  Future<void> loginUser() async {
    if (kDebugMode) {
      print(loginEmailController.text);
      print(loginPassController.text);
    }

    AppUtility.hideKeyboard();

    startLoader();
    try {
      User? user = await AuthServices.signInWithEmailPassword(
          loginEmailController.text.trim(), loginPassController.text.trim());
      if (kDebugMode) {
        print("$user");
      }
      if (user != null) {
        // await updateFcm();
        if (kDebugMode) {
          print("not null");
          print("user login");
        }
        passwordController.clear();

        handleSignIn(user.email!);
      } else {
        stopLoader();
        ShowMessage.snackBar("Authentication Error",
            "please check your login credential", false);
      }
    } catch (er) {
      stopLoader();
      String error = er.toString();
      if (kDebugMode) {
        print("error = $error");
      }
      error.contains('WRONG_PASSWORD')
          ? Get.snackbar("Authentication Error", "Wrong password",
              colorText: Colors.white,
              borderRadius: 10,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              backgroundColor: Colors.red)
          : error.contains('USER_NOT_FOUND')
              ? Get.snackbar("Authentication Error", "user not found",
                  colorText: Colors.white,
                  borderRadius: 10,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  backgroundColor: Colors.red)
              : Get.snackbar(
                  "Authentication Error", "please check your login credential",
                  colorText: Colors.white,
                  borderRadius: 10,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  backgroundColor: Colors.red);
    }
  }

  Future<void> handleSignIn(String email) async {

    if (kDebugMode) {
      print("email $email");
    }
    appUserData = (await getUserFromDB(email))!;
    appUserData.location = currentLocation;
    appUserData.address=
    await _loc.getAddressFromLatLong(appUserData.location);

    FBCollections.users
        .doc(appUserData.email)
        .update(appUserData.toJson())
        .then((value) async {
      AppUser.user = appUserData;
    });
    if (kDebugMode) {
      print(
          "=============${Provider.of<AuthProvider>(Get.context!, listen: false).appUserData.toJson()}=============");
      print("user found = ${appUserData.toJson()}");
    }
    await fetchAllUsers();
    await p.fetchMyChatRooms();

    Get.offAll(const DashBoard(0));

    updateFCM(AppUtility.freshFCM);
  }

  Future<void> updateFcm() async {
    await FBCollections.users
        .doc(emailController.text)
        .update({"fcm": AppUtility.myFcmToken});
  }

  //////////////////////////////////////FORGOT PASSWORD/////////////////////////////

  Future forgotPassword(String email) async {
    AppUtility.hideKeyboard();
    await AuthServices.sendResetPassEmail(email.trim());
    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
  }

  //////////////////////////////PROFILE//////////////////////////////////////
// To move slider on front end
  Future<void> setDistance(double value) async {
    appUserData.distanceToFindUser = value;
    await saveDistance(appUserData.distanceToFindUser);

    notifyListeners();
  }

  // To save data on Firebase
  Future<void> saveDistance(double value) async {
    await FBCollections.users
        .doc(appUserData.email)
        .update({"distance_to_find_user": value});

    notifyListeners();
  }

  final LocationServices _loc = LocationServices();
  late Location currentLocation;

  Future<void> fetchCurrentLatLng() async {
    var internet = await check();
    if (internet) {
      Position pos = await _loc.getCurrentLocation();
      currentLocation = Location(lat: pos.latitude, long: pos.longitude);
      if (kDebugMode) {
        print("current location is ${currentLocation.toJson()}");
      }
    } else {
      Provider.of<AuthProvider>(Get.context!, listen: false).stopLoader();
      Get.snackbar("No internet Connection", "Please connect internet",
          colorText: AppConfig.colors.whiteColor,
          backgroundColor: AppConfig.colors.secondaryThemeColor);
    }
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  StreamSubscription<List<UserData>>? allUserStream;
  List<UserData> nearByUser = [];

  Future<void> fetchAllUsers() async {
    var value = AuthServices.getAllUsers();
    if (allUserStream == null) {
      value.listen((event) async {
        nearByUser.clear();
        var temp = event.where((b) => b.email != AppUser.user.email).toList();
        for (var b in temp) {
          double dist =
              LocationServices().findDistance(currentLocation, b.location);

          if (dist <= AppUser.user.distanceToFindUser) {
            nearByUser.add(b);
          }

          notifyListeners();
        }
        Markers.markers.clear();
        for (var markerUser in nearByUser) {



          Markers.onAddMarkerButtonPressed(markerUser);
        }
      });

      if (kDebugMode) {
        print("total nearBy users are : ${nearByUser.length}");
      }
    }
  }

  void onDispose() {
    allUserStream?.cancel();
  }
}
