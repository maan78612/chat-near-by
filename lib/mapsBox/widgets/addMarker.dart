import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:chat_module/ModelClasses/userData.dart';
import 'package:chat_module/constants/app_constants.dart';
import 'package:chat_module/utilities/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utilities/styles.dart';
import 'customResponsiveBtmSheet.dart';

class Markers {
  static Set<Marker> markers = {};
  static String iconUrl = "";
  static BitmapDescriptor? myMarker;
  static Uint8List? markerImageBytes;

  static Future<void> customMarker(UserData markerUser) async {
    iconUrl = markerUser.imageUrl;
    if (kDebugMode) {
      print("user image is $iconUrl");
      print("user image is ${markerUser.imageUrl}");
    }

    if (iconUrl == "") {
      ByteData data = await rootBundle.load(AppConfig.images.logo);
      markerImageBytes = data.buffer.asUint8List();
    } else {
      final File markerImageFile =
          await DefaultCacheManager().getSingleFile(iconUrl);
      markerImageBytes = await markerImageFile.readAsBytes();
    }
    Codec codec = await instantiateImageCodec(markerImageBytes!,
        targetWidth: iconUrl == "" ? 75 : 60);
    FrameInfo fi = await codec.getNextFrame();

    final Uint8List? markerImage =
        (await fi.image.toByteData(format: ImageByteFormat.png))
            ?.buffer
            .asUint8List();

    myMarker = BitmapDescriptor.fromBytes(markerImage!);
    addMarker(markerUser, myMarker!);
  }

  static addMarker(UserData markerUser, BitmapDescriptor myMarker) {
    if (kDebugMode) {
      print("marker added for ${markerUser.firstName} ${markerUser.lastName}");
    }
    markers.add(Marker(
      draggable: false,
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(markerUser.location.lat.toString()),
      position: LatLng(markerUser.location.lat, markerUser.location.long),
      infoWindow: InfoWindow(
          title:
              "Hi! My name is ${markerUser.firstName} ${markerUser.lastName}",
          snippet: 'Click to start chat ',
          onTap: () {
            CustomBottomSheet.customResponsiveBtmSheet(markerUser);
            // Get.bottomSheet(CustomDialogBox(markerUser: markerUser));
          }),
      icon: myMarker,
    ));
  }


}
