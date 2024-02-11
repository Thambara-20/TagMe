import 'dart:convert';
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

Future<List<Event>> loadOngoingEventsFromCache(String userClub) async {
  final prefs = await SharedPreferences.getInstance();
  final eventsJson = prefs.getString("events");
  if (eventsJson != null) {
    final List<dynamic> decoded = json.decode(eventsJson);
    final List<Event> events = decoded
        .map((eventJson) => Event.fromJson(eventJson))
        .where((event) =>
            event.endTime.isAfter(DateTime.now()) &&
            event.startTime.isBefore(DateTime.now()) &&
            event.club == userClub.split(" ")[2])
        .toList();
    return events;
  }
  return [];
}

Future<void> saveEventsToCache(List<Event> events) async {
  final prefs = await SharedPreferences.getInstance();
  final eventsJson = events.map((event) => event.toJson()).toList();
  await prefs.setString("events", json.encode(eventsJson));
}

Future<bool> checkLoggedInUser() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

Future<AppUser> getLoggedInUserInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final String uid = prefs.getString('userUid') ?? '';
  final String userEmail = prefs.getString('userEmail') ?? '';
  final bool isAdmin = prefs.getBool('isAdmin') ?? false;

  return AppUser(
    uid: uid,
    email: userEmail,
    isAdmin: isAdmin,
  );
}

Future<void> storeLoggedInUser(AppUser user) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);
  await prefs.setString('userUid', user.uid);
  await prefs.setString('userEmail', user.email);
  await prefs.setBool('isAdmin', user.isAdmin);
}

Future<void> removeLoggedInUser() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false);
  await prefs.remove('userUid');
  await prefs.remove('userEmail');
  await prefs.remove('isAdmin');
  await prefs.remove('userRole');
  await prefs.remove('memberId');
  await prefs.remove('name');
  await prefs.remove('isProfileUpdated');
  await prefs.remove('userClub');
}

Future<void> updateUserRole(Prospect prospect) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userUid', prospect.uid);
  await prefs.setBool('isProfileUpdated', true);
  await prefs.setString("name", prospect.name);
  await prefs.setString('userRole', prospect.role);
  await prefs.setString("memberId", prospect.memberId);
  await prefs.setString('userEmail', prospect.email);
  await prefs.setString('userClub', prospect.userClub);
}

Future<Prospect> getLoggedUserRoleData() async {
  final prefs = await SharedPreferences.getInstance();
  final String uid = prefs.getString('userUid') ?? '';
  final String userRole = prefs.getString('userRole') ?? '';
  final String memberId = prefs.getString('memberId') ?? '';
  final String name = prefs.getString('name') ?? '';
  final String email = prefs.getString('userEmail') ?? '';
  final String userClub = prefs.getString('userClub') ?? '';

  return Prospect(
    email: email,
    uid: uid,
    name: name,
    role: userRole,
    userClub: userClub,
    memberId: memberId,
  );
}

Future<bool> isProfileUpdated() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isProfileUpdated') ?? false;
}
