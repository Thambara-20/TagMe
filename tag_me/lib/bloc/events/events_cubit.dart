import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tag_me/bloc/events/events_state.dart';
import 'package:tag_me/utilities/event.dart';
abstract class EventsEvent {}

class FetchEvents extends EventsEvent {}

// EventsCubit class
class EventsCubit extends Cubit<EventsState> {
  final TextEditingController searchController = TextEditingController();

  EventsCubit() : super(EventsState(events: [], isLoading: true));

  void fetchEvents() async {
    try {
      emit(state.copyWith(isLoading: true));
      List<Event> events = await _getEvents();
      emit(state.copyWith(events: events, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<List<Event>> _getEvents() async {
    QuerySnapshot eventsSnapshot = await FirebaseFirestore.instance
        .collection('events')
        .get();

    return eventsSnapshot.docs.map((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

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
    }).toList();
  }
}
