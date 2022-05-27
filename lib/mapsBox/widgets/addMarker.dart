
import 'package:chat_module/ModelClasses/userData.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'customDialogForMarker.dart';

class Markers {
  static Set<Marker> markers = {};

  static onAddMarkerButtonPressed(UserData markerUser) {
    if (kDebugMode) {
      print("marker added for ${markerUser.firstName} ${markerUser.lastName}");
    }
    markers.add(Marker(
      draggable: false,
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(markerUser.location.lat.toString()),
      position: LatLng(markerUser.location.lat, markerUser.location.long),
      infoWindow:  InfoWindow(
        title: "Hi! My name is ${markerUser.firstName} ${markerUser.lastName}",
        snippet: 'Lets\'s chat',
        onTap: (){
          Get.dialog(CustomDialogBox( markerUser: markerUser));
        }
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }


}
