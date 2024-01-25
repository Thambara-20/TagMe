// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/HomePage/EventBox/EventBox.dart';
import 'package:tag_me/utilities/event.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Event> ongoingEvents = [
    Event(
      creator: 'User 1',
      name: 'Event 1',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 2)),
      participants: ['User 1', 'User 2', 'User 3'],
      isParticipating: true,
      location: 'Location 1',
      geoPoint: List<double>.from([ 7.0, 81.0]),
    ),
    Event(
      creator: 'User 2',
      name: 'Event 2',
      startTime: DateTime.now().add(const Duration(days: 1)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
      participants: ['User 1', 'User 2', 'User 3'],
      isParticipating: false,
      location: 'Location 2',
      geoPoint: List<double>.from([ 6.08, 80.66]),
    ),
    Event(
      creator: 'User 3',
      name: 'Event 2',
      startTime: DateTime.now().add(const Duration(days: 1)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
      participants: ['User 1', 'User 2', 'User 3'],
      isParticipating: false,
      location: 'Location 2',
      geoPoint: List<double>.from([ 7.0, 81.0]),
    ),
    Event(
      creator: 'User 4',
      name: 'Event 2',
      startTime: DateTime.now().add(const Duration(days: 1)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
      participants: ['User 1', 'User 2', 'User 3'],
      isParticipating: false,
      location: 'Location 2',
      geoPoint: List<double>.from([ 7.0, 81.0]),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: khomePageBackgroundColor,
        child: ListView.builder(
          itemCount: ongoingEvents.length,
          itemBuilder: (context, index) {
            return EventBox(event: ongoingEvents[index]);
          },
        ),
      ),
    );
  }
}
