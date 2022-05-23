import 'package:chat_module/utilities/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_constants.dart';

class PeopleTile extends StatelessWidget {
  final String name;
  final String img;
  final int msgCount;
  final Function() onTap;

  PeopleTile(
      {required this.name,
      this.msgCount = 0,
      required this.onTap,
      required this.img});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        tileColor: AppConfig.colors.themeColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding:
            EdgeInsets.symmetric(horizontal: Get.width * 0.02, vertical: 2),
        onTap: onTap,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: img == ""
                  ? AssetImage(
                      AppConfig.images.addImgIcon,
                    )
                  : NetworkImage(img) as ImageProvider,


              maxRadius: Dimensions.radiusLarge,
              backgroundColor: Colors.transparent,

            ),
            // ClipRRect(
            //     borderRadius: BorderRadius.circular(8),
            //     child: img == "" ? const SizedBox() : Image.network(img)),
            SizedBox(width: Get.width * 0.03),
            Text(
              name,
            ),
          ],
        ),
        trailing: msgCount == 0
            ? const SizedBox(
                width: 0,
                height: 0,
              )
            : Container(
                alignment: const Alignment(0.0, 0.2),
                width: 32.0,
                height: 18.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.0),
                  color: const Color(0xFFEB2D8C),
                ),
                child: Text(
                  '$msgCount',
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
              ),
      ),
    );
  }
}
