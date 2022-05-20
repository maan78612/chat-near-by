import 'package:flutter/foundation.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';

import '../ModelClasses/location.dart';

class LocationServices {
  Future<String> getAddressByLatLng(double lat, double lng) async {
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: lat, longitude: lng, googleMapApiKey: "GOOGLE_MAP_API_KEY");
    String address = data.address;

    if (kDebugMode) {
      print("GEOCODER :::: FOUND : $address");
    }
    return address;
  }

  Future<Position> getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      if (kDebugMode) {
        print("permission denied");
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${position.latitude}');
    return position;
  }

  double findDistance(Location myLocation, Location bookLocation) {
    double distance = Geolocator.distanceBetween(
        myLocation.lat, myLocation.long, bookLocation.lat, bookLocation.long);
    distance = distance / 1609;
    print("Distance is = $distance");
    return distance;
  }
}
