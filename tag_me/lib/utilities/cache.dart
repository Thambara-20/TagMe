import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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

void listenToEvents() async {
  FirebaseFirestore.instance
      .collection('events')
      .snapshots()
      .listen((snapshot) async {
    await saveEventsToCache(snapshot.docs.map((document) {
      Map<String, dynamic> data = document.data();

      return Event(
        id: document.id,
        creator: data['creator'] ?? '',
        name: data['name'] ?? '',
        startTime: (data['startTime'] as Timestamp).toDate(),
        endTime: (data['endTime'] as Timestamp).toDate(),
        location: data['location'] ?? '',
        geoPoint: List<double>.from(
          (data['geoPoint'] as List<dynamic>?)?.cast<double>() ?? [],
        ),
        coordinates: Map<String, double>.from(data['coordinates'] ?? {}),
        participants: List<String>.from(
          (data['participants'] as List<dynamic>?)?.cast<String>() ?? [],
        ),
        isParticipating: data['isParticipating'] ?? false,
      );
    }).toList());
  });
}
