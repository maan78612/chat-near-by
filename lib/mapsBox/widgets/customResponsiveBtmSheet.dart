import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_module/ModelClasses/userData.dart';
import 'package:chat_module/mapsBox/Provider/mapProvider.dart';
import 'package:chat_module/utilities/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../utilities/styles.dart';

class CustomBottomSheet {
  static void customResponsiveBtmSheet(UserData markerUser) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: Get.context!,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return BottomSheetContent(markerUser: markerUser);
        });
  }
}

class BottomSheetContent extends StatefulWidget {
  final UserData markerUser;

  const BottomSheetContent({required this.markerUser});

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.ease);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      alignment: Alignment.topCenter,
      decoration: ShapeDecoration(
        color: AppConfig.colors.whiteColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(17),
            topRight: Radius.circular(17),
          ),
        ),
      ),
      child: ScaleTransition(
        scale: scaleAnimation,
        child: contentBox(context),
      ),
    ));
  }

  contentBox(context) {
    return Consumer<MapProvider>(builder: (context, mapPro, _) {
      return Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 40.h,
              ),
              Text(
                "${widget.markerUser.firstName} ${widget.markerUser.lastName}",
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                widget.markerUser.address,
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: AppConfig.colors.secondaryThemeColor,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22.h,
              ),
              mapPro.isLoading
                  ? CircularProgressIndicator(
                      color: AppConfig.colors.secondaryThemeColor,
                    )
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          mapPro.startChat(widget.markerUser.email);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              AppConfig.colors.blackGrey),
                        ),
                        child: Text(
                          "Let's Chat",
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: AppConfig.colors.whiteColor),
                        ),
                      ),
                    ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
          Positioned(
            top: -40.h,
            child:

            CircleAvatar(
              backgroundImage: widget.markerUser.imageUrl != ""
                  ? CachedNetworkImageProvider(widget.markerUser.imageUrl)
                  : AssetImage(
                      AppConfig.images.addImgIcon,
                    ) as ImageProvider,
              radius: 40.h,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      );
    });
  }

}
