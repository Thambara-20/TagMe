// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/utilities/dateConvert.dart';

import '../HomePage/EventBox/EventBox.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  static const String routeName = '/HistoryPage';

  @override
  Widget build(BuildContext context) {
    var userHistory = [
      Event(
        name: 'Event 1',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        participants: 1,
        userAttending: true,
        location: 'Location 1',
        geoPoint: [0, 0],
      ),
      Event(
        name: 'Event 2',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        participants: 2,
        userAttending: false,
        location: 'Location 2',
        geoPoint: [0, 0],
      ),
      Event(
        name: 'Event 3',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        participants: 3,
        userAttending: true,
        location: 'Location 3',
        geoPoint: [0, 0],
      ),
      Event(
        name: 'Event 4',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        participants: 4,
        userAttending: false,
        location: 'Location 4',
        geoPoint: [0, 0],
      ),
      Event(
        name: 'Event 5',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        participants: 5,
        userAttending: true,
        location: 'Location 5',
        geoPoint: [0, 0],
      ),
      Event(
        name: 'Event 6',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        participants: 6,
        userAttending: false,
        location: 'Location 6',
        geoPoint: [0, 0],
      ),
      Event(
        name: 'Event 7',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        participants: 7,
        userAttending: true,
        location: 'Location 7',
        geoPoint: [0, 0],
      ),
      Event(
        name: 'Event 8',
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        participants: 8,
        userAttending: false,
        location: 'Location 8',
        geoPoint: [0, 0],
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('My History'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: userHistory.length,
        itemBuilder: (context, index) {
          return _buildEventCard(context, userHistory[index]);
        },
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      color: keventBoxColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: const BorderSide(
          color: keventBoxBorderColor,
          width: 0.5,
        ),
      ),
      child: ListTile(
        title: Center(
          child: Text(
            event.name,
            style: keventBoxLargeTextStyle,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              'Start Time:',
              formatDateTime(event.startTime),
              Icons.access_time,
            ),
            _buildDetailRow(
              'End Time:',
              formatDateTime(event.endTime),
              Icons.access_time,
            ),
            _buildDetailRow(
              'Participants:',
              '${event.participants}',
              Icons.people,
            ),
            _buildDetailRow(
              'Location:',
              event.location,
              Icons.location_on,
            ),
            _buildDetailRow(
              'User Attending:',
              event.userAttending ? 'Yes' : 'No',
              Icons.person,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: kbuttonColorBlue),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              '$label $value',
              style: keventBoxNormalTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
