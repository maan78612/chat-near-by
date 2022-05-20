
import 'package:chat_module/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'Provider/auth.dart';
import 'chatbox/provider/chat_provider.dart';
import 'notificationBox/fmsg_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(MyApp());
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
        // Provider(create: (_) => AuthProvider()),
        // Provider(create: (_) => ChatProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
         return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Books Exchange',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home:child,
          );
        },
        child: FBMessaging(
          page: SplashScreen(),
        ))

    );
  }
}