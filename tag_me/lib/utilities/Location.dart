// ignore_for_file: file_names, prefer_if_null_operators, unnecessary_null_comparison

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<void> askForLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future<bool> checkInGeoPointArea(Map<String, double> eventGeoPoint) async {
  try {
    Position userPosition = await determinePosition();
    double distanceInMeters = Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      eventGeoPoint['latitude']!,
      eventGeoPoint['longtitude']!,
    );
    double thresholdDistance = 1000;
    return distanceInMeters <= thresholdDistance;
  } catch (e) {
    return false;
  }
}

Future<GeoPoint> getGeoPoint() async {
  Position position = await determinePosition();
  return GeoPoint(
    latitude: position.latitude,
    longitude: position.longitude,
  );
}

Future<GeoPoint> getGeoPointFromLocation(
    Map<String, double> coordinates) async {
  double latitude = coordinates['latitude']!;
  double longtitude = coordinates['longtitude']!;
  return GeoPoint(latitude: latitude, longitude: longtitude);
}

Future<String> getArea() async {
  try {
    List<Placemark> placemarks = [];
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return '${place.locality}, ${place.country}';
  } catch (e) {
    return '';
  }
}
