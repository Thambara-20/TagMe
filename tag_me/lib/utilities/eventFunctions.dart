// event_functions.dart

// ignore_for_file: file_names, empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tag_me/models/event.dart';
import 'package:tag_me/utilities/cache.dart';

Future<void> updateEvent(Event newEvent) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (newEvent.id.isNotEmpty) {
      await firestore.collection('events').doc(newEvent.id).update({
        'creator': newEvent.creator,
        'name': newEvent.name,
        'startTime': newEvent.startTime,
        'endTime': newEvent.endTime,
        'location': newEvent.location,
        'coordinates': newEvent.coordinates,
        'geoPoint': newEvent.geoPoint,
        'participants': [
          "user1",
          "user2",
          "user3",
          "user4",
          "user5",
          "user6",
          "user7",
          "user8",
          "user9",
          "user10"
        ],
        'isParticipating': newEvent.isParticipating,
      });
    }
  } catch (e) {}
}

Future<void> deleteEvent(String id) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (id.isNotEmpty) {
      await firestore.collection('events').doc(id).delete();
    }
  } catch (e) {}
}

Future<void> addEvent(Event newEvent) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference documentReference =
        await firestore.collection('events').add({
      'creator': newEvent.creator,
      'name': newEvent.name,
      'startTime': newEvent.startTime,
      'endTime': newEvent.endTime,
      'location': newEvent.location,
      'coordinates': newEvent.coordinates,
      'geoPoint': newEvent.geoPoint,
      'participants': newEvent.participants,
      'isParticipating': newEvent.isParticipating,
    });

    newEvent.id = documentReference.id;
  } catch (e) {}
}

Future<void> addParticipant(String eventId) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await firestore.collection('events').doc(eventId).update({
        'participants': FieldValue.arrayUnion([user.displayName ?? '']),
      });
    }
  } catch (e) {}
}

bool checkStartTime(DateTime startTime) {
  DateTime now = DateTime.now();
  if (startTime.isBefore(now)) {
    return false;
  }
  return true;
}

void listenToEvents() async {
  try {
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
  } catch (e) {}
}
