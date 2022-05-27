import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';

import '../ModelClasses/location.dart' as loc;

class LocationServices {
  Future<String> getAddressFromLatLong(loc.Location loc) async {
    String address = "";
    List<Placemark>? placemarks =
        await placemarkFromCoordinates(loc.lat, loc.long);

    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    print("user address is $address");
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

  double findDistance(loc.Location myLocation, loc.Location bookLocation) {
    double distance = Geolocator.distanceBetween(
        myLocation.lat, myLocation.long, bookLocation.lat, bookLocation.long);
    distance = distance / 1609;
    if (kDebugMode) {
      print("Distance is = $distance");
    }
    return distance;
  }
}
