
import 'package:chat_module/constants/app_constants.dart';
import 'package:flutter/material.dart';




class NotificationApps extends StatefulWidget {
  @override
  _NotificationAppsState createState() => _NotificationAppsState();
}

class _NotificationAppsState extends State<NotificationApps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppConfig.colors.whiteColor,
        body: const Center(child: Text("Home"),),
      );

  }


}
