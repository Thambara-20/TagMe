// app_state.dart

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tag_me/utilities/cache.dart';
import 'event.dart';

class AppState extends ChangeNotifier {
  List<Event> events = [];
  bool isDataLoaded = false;

  // Add any other global state you need

  // Singleton pattern for the global store
  static final AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal();

  // Method to update events
  void updateEvents(List<Event> newEvents) {
    events = newEvents;
    notifyListeners();
  }

  // Method to load events from cache only once
  Future<void> loadEventsFromCacheOnce() async {
    if (!isDataLoaded) {
      final loadedEvents = await loadEventsFromCache();
      events = loadedEvents;
      isDataLoaded = true;
      notifyListeners();
    }
  }
}
