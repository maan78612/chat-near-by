import 'dart:async';

import 'package:chat_module/ModelClasses/userData.dart';
import 'package:chat_module/mapsBox/widgets/addMarker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../Provider/auth.dart';


class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();



  static  final CameraPosition initialCameraPosition = CameraPosition(
      bearing: 192.8334901395799,
      target:  LatLng(AppUser.user.location.lat, AppUser.user.location.long),
      tilt: 59.440717697143555,
      zoom: 10);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      return  Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          zoomGesturesEnabled: true,
          tiltGesturesEnabled: false,
          initialCameraPosition: initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Markers.markers,
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: _goToTheLake,
        //   label: const Text('To the lake!'),
        //   icon: const Icon(Icons.directions_boat),
        // ),
      );
    });

  }


}