// event_functions.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tag_me/utilities/event.dart';

Future<void> updateEvent(Event newEvent) async {
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
      'participants': newEvent.participants,
      'isParticipating': newEvent.isParticipating,
    });
  }
}

Future<void> deleteEvent(String id) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  if (id.isNotEmpty) {
    await firestore.collection('events').doc(id).delete();
  }
}

Future<void> addEvent(Event newEvent) async {
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
}
