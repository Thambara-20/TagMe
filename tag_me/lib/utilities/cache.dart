import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag_me/models/event.dart';
import 'package:tag_me/models/user.dart';
import 'package:tag_me/utilities/clubServices.dart';

Future<List<String>> loadDistrictsFromCache() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final districtsJson = prefs.getString("districts");

    if (districtsJson != null) {
      final List<dynamic> decoded = json.decode(districtsJson);
      return decoded.map((district) => district.toString()).toList();
    }

    final List<String> districts = await findDistricts();
    saveDistrictsToCache(districts);
    return districts;
  } catch (e) {
    return [];
  }
}

Future<void> saveDistrictsToCache(List<String> districts) async {
  final prefs = await SharedPreferences.getInstance();
  final districtsJson = districts.map((district) => district).toList();
  await prefs.setString("districts", json.encode(districtsJson));
}

Future<List<Event>> loadEventsFromCache() async {
  final prefs = await SharedPreferences.getInstance();
  final eventsJson = prefs.getString("events");
  if (eventsJson != null) {
    final List<dynamic> decoded = json.decode(eventsJson);

    return decoded.map((eventJson) => Event.fromJson(eventJson)).toList();
  }
  return [];
}

Future<List<Event>> loadOngoingEventsFromCache(String district) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString("events");

    if (eventsJson != null) {
      final List<dynamic> decoded = json.decode(eventsJson);

      final List<Event> events = decoded
          .map((eventJson) => Event.fromJson(eventJson))
          .where((event) =>
              event.endTime.isAfter(DateTime.now()) &&
              event.startTime.isBefore(DateTime.now()) &&
              event.district == district)
          .toList();

      return events;
    }
    return [];
  } catch (e) {
    return [];
  }
}


Future<void> saveEventsToCache(List<Event> events) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = events.map((event) => event.toJson()).toList();
    await prefs.setString("events", json.encode(eventsJson));
  } catch (e) {
    Logger().e('Error saving events to cache: $e');
    throw Exception('Error saving events to cache: $e');
  }
}

Future<bool> checkLoggedInUser() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    Logger().log(Level.info, "Check User logged in: ${prefs.getBool('isLoggedIn')}");
    return prefs.getBool('isLoggedIn') ?? false;
  } catch (e) {
    Logger().e('Error checking logged-in user): $e');
    throw Exception('Error checking logged-in user: $e');
  }
}

Future<AppUser> getLoggedInUserInfo() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final String uid = prefs.getString('userUid') ?? '';
    final String userEmail = prefs.getString('userEmail') ?? '';
    final bool isAdmin = prefs.getBool('isAdmin') ?? false;

    return AppUser(
      uid: uid,
      email: userEmail,
      isAdmin: isAdmin,
    );
  } catch (e) {
    Logger().e('Error getting logged-in user info: $e');
    throw Exception('Error getting logged-in user info: $e');
  }
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
  await prefs.remove('designation');
  await prefs.remove('district');
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
  await prefs.setString('designation', prospect.designation);
  await prefs.setString('district', prospect.district);
}

Future<Prospect> getLoggedUserRoleData() async {
  final prefs = await SharedPreferences.getInstance();
  final String uid = prefs.getString('userUid') ?? '';
  final String userRole = prefs.getString('userRole') ?? '';
  final String memberId = prefs.getString('memberId') ?? '';
  final String name = prefs.getString('name') ?? '';
  final String email = prefs.getString('userEmail') ?? '';
  final String userClub = prefs.getString('userClub') ?? '';
  final String designation = prefs.getString('designation') ?? '';
  final String district = prefs.getString('district') ?? '';

  return Prospect(
    email: email,
    uid: uid,
    name: name,
    role: userRole,
    userClub: userClub,
    memberId: memberId,
    designation: designation,
    district: district,
  );
}

Future<bool> isProfileUpdated() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isProfileUpdated') ?? false;
}
