import 'package:chat_module/Provider/auth.dart';
import 'package:chat_module/constants/app_constants.dart';
import 'package:chat_module/utilities/dimension.dart';
import 'package:chat_module/utilities/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // ConnectivityServices _connect = ConnectivityServices();
  void navigateToNext() {
    Future.delayed(const Duration(milliseconds: 1600), () => onInit());
  }

  onInit() async {
    // bool connected =
    //     await Provider.of<AuthProvider>(context, listen: false).check();
    // if (!connected) {
    //   Get.to(NoInternetScreen());
    //   return;
    // }
    Future.delayed(const Duration(milliseconds: 100), () {
      Provider.of<AuthProvider>(context, listen: false).autoLogin();
    });
  }

  @override
  void initState() {
    navigateToNext();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: const Alignment(-0.04, -0.01),
      decoration: BoxDecoration(color: AppConfig.colors.themeColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Chat Near By',
            style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: AppConfig.colors.whiteColor),
          ),
          Image.asset(
            AppConfig.images.splash,

          ),
        ],
      ),
    ));
  }
}
