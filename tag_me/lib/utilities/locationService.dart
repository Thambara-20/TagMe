// ignore_for_file: file_names, prefer_if_null_operators, unnecessary_null_comparison

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag_me/utilities/eventServices.dart';

Future<void> askForLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
}

Future<Position> determinePosition() async {
  try {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  } catch (e) {
    Logger().e("Error determining position: $e");
    rethrow;
  }
}

Future<bool> checkInGeoPointArea(Map<String, double> eventGeoPoint) async {
  try {
    await getEventLocationRange();
    final prefs = await SharedPreferences.getInstance();
    late double locationRange;
    locationRange = prefs.getDouble("location_range") ?? 500.0;
    Position userPosition = await determinePosition();
    double distanceInMeters = Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      eventGeoPoint['latitude']!,
      eventGeoPoint['longtitude']!,
    );
    double thresholdDistance = locationRange;
    return distanceInMeters <= thresholdDistance;
  } catch (e) {
    Logger().e("Error checking in geo point area: $e");
    return false;
  }
}

Future<GeoPoint> getGeoPoint() async {
  try {
    Position position = await determinePosition();
    return GeoPoint(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  } catch (e) {
    throw Exception('Error getting GeoPoint: $e');
  }
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
