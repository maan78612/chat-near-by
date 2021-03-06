import 'package:chat_module/splash_screen.dart';
import 'package:chat_module/translations/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'biometricBox/Provider/biometricProvider.dart';
import 'firebase_options.dart';
import 'Provider/auth.dart';
import 'chatbox/provider/chat_provider.dart';
import 'mapsBox/Provider/mapProvider.dart';
import 'notificationBox/fmsg_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /* For Localization*/
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  /* For firebase back-ground messaging*/
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  /* Wrap MyApp() with EasyLocalization for localization*/
  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en'),
      Locale('ar'),
      Locale('fr'),
    ],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'), // if it does not find any locale
    assetLoader: const CodegenLoader(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ConnectivityServices _con = ConnectivityServices();

  @override
  void initState() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    // _con.startConnectionStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ChatProvider()),
          ChangeNotifierProvider(create: (_) => MapProvider()),
          ChangeNotifierProvider(create: (_) => BiometricProvider()),
        ],
        child: ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (BuildContext context, Widget? child) {
              return GetMaterialApp(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,

                debugShowCheckedModeBanner: false,
                title: 'Chat Near BY',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: child,
              );
            },
            child: FBMessaging(
              page: SplashScreen(),
            )));
  }
}
