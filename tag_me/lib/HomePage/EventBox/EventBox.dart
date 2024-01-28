// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/utilities/Location.dart';
import 'package:tag_me/utilities/dateConvert.dart';
import 'package:tag_me/models/event.dart';
import 'package:tag_me/utilities/eventFunctions.dart';

class EventBox extends StatefulWidget {
  final Event event;

  const EventBox({Key? key, required this.event}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventBoxState createState() => _EventBoxState();
}

class _EventBoxState extends State<EventBox> {
  bool _userAttending = false;

  @override
  void initState() {
    super.initState();
    _userAttending = widget.event.isParticipating;
  }

  @override
  Widget build(BuildContext context) {
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
            widget.event.name,
            style: keventBoxLargeTextStyle,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Start Time:',
                formatDateTime(widget.event.startTime), Icons.access_time),
            _buildDetailRow('End Time:', formatDateTime(widget.event.endTime),
                Icons.access_time),
            _buildDetailRow('Participants:',
                '${widget.event.participants.length}', Icons.people),
            _buildDetailRow(
                'Location:', widget.event.location, Icons.location_on),
            _buildDetailRow(
                'User Attending:', widget.event.isParticipating, Icons.person),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _userAttending ? null : _verifyAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: kbuttonColorBlue,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              child: Center(
                child: Text(
                  _userAttending ? 'Attendance Marked' : 'Mark Attendance Now',
                  style: _userAttending
                      ? keventBoxDisabledButtonStyle
                      : keventBoxEnabledButtonStyle,
                ),
              ),
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
          if (label == 'User Attending:')
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$label ',
                    style: keventBoxNormalTextStyle,
                  ),
                  Text(_userAttending ? 'Yes' : 'No',
                      style: _userAttending
                          ? kwarningTextGreenStyle
                          : kwarningTextRedStyle),
                ],
              ),
            )
          else
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

  void _verifyAttendance() {
    Map<String, double> eventGeoPoint =
        widget.event.coordinates; // event's latitude and longitude
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Verify Attendance'),
          content: const Text(
            'Please provide the required verification to mark your attendance.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                bool isInGeoPointArea =
                    await checkInGeoPointArea(eventGeoPoint);
                if (isInGeoPointArea) {
                  setState(() {
                    _userAttending = !_userAttending;
                    addParticipant(widget.event.id);
                  });
                  _close();
                } else {
                  // ignore: use_build_context_synchronously
                  if (!mounted) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You are not in the required area'),
                    ),
                  );
                }
              },
              child: const Text('Verify'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _close() {
    Navigator.of(context).pop();
  }
}
