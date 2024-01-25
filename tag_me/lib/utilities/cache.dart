import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag_me/utilities/event.dart';

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
