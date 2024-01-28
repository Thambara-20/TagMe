import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag_me/models/event.dart';
import 'package:tag_me/models/user.dart';


Future<List<Event>> loadEventsFromCache() async {
  final prefs = await SharedPreferences.getInstance();
  final eventsJson = prefs.getString("events");
  if (eventsJson != null) {
    final List<dynamic> decoded = json.decode(eventsJson);

    return decoded.map((eventJson) => Event.fromJson(eventJson)).toList();
  }
  return [];
}

Future<void> saveEventsToCache(List<Event> events) async {
  final prefs = await SharedPreferences.getInstance();
  final eventsJson = events.map((event) => event.toJson()).toList();
  await prefs.setString("events", json.encode(eventsJson));
}

 Future<void> storeLoggedInUser(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userUid', user.uid);
    await prefs.setString('userEmail', user.email);
    await prefs.setString('userDisplayName', user.displayName);
    await prefs.setBool('isAdmin', user.isAdmin);
  }

  Future<void> removeLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userUid');
    await prefs.remove('userEmail');
    await prefs.remove('userDisplayName');
    await prefs.remove('isAdmin');
  }

  Future<bool> checkLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<AppUser> getLoggedInUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final String uid = prefs.getString('userUid') ?? '';
    final String userEmail = prefs.getString('userEmail') ?? '';
    final String userDisplayName = prefs.getString('userDisplayName') ?? '';
    final bool isAdmin = prefs.getBool('isAdmin') ?? false;

    return AppUser(
      uid: uid,
      email: userEmail,
      displayName: userDisplayName,
      isAdmin: isAdmin,
    );
  }

