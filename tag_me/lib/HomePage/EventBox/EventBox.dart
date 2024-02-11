// ignore_for_file: file_names


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tag_me/HomePage/ParticipantsPage/ParticipantsPage.dart';
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
  bool isInGeoPointArea = false;

  @override
  void initState() {
    super.initState();
    _userAttending = widget.event.participants.contains(FirebaseAuth.instance.currentUser?.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      color: keventBoxColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(
          color: keventCardBorderColor,
          width: 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.only(left: 14.0, right: 14.0),
          title: ListTile(
            leading: const Icon(Icons.event),
            title: Center(
              child: Text(
                'Project: ${widget.event.name}',
                style: keventBoxLargeTextStyle,
              ),
            ),
          ),
          childrenPadding: const EdgeInsets.all(14.0),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              'Start Time:',
              formatDateTime(widget.event.startTime),
              Icons.access_time,
            ),
            _buildDetailRow(
              'End Time:',
              formatDateTime(widget.event.endTime),
              Icons.access_time,
            ),
            _buildDetailRow(
              'Participants:',
              '${widget.event.participants.length}',
              Icons.people,
            ),
            _buildDetailRow(
              'Location:',
              widget.event.location,
              Icons.location_on,
            ),
            _buildDetailRow(
              'User Attending:',
              widget.event.isParticipating ? 'Yes' : 'No',
              Icons.person,
            ),
            const SizedBox(height: 8.0),
            ElevatedButton.icon(
              onPressed: _userAttending ? null : _verifyAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: kbuttonColorBlue,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              label: Center(
                child: Text(
                  _userAttending ? 'Attendance Marked' : 'Mark Attendance Now',
                  style: _userAttending
                      ? keventBoxDisabledButtonStyle
                      : keventBoxEnabledButtonStyle,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kNavbarButtonBackgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: const Size(double.infinity, 40),
              ),
              onFocusChange: (bool hasFocus) {
                // Change the shadow when focused
                ElevatedButton.styleFrom(
                  elevation: hasFocus ? 4 : 2,
                );
              },
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParticipantsPage(
                        participants: widget.event.participants,
                        project: widget.event.name),
                  ),
                );
              },
              child: const Text(
                  'Participants', style: knormalTextWhiteStyle,), // Replace with your desired button text
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
                  Text(
                    _userAttending ? 'Yes' : 'No',
                    style: _userAttending
                        ? kwarningTextGreenStyle
                        : kwarningTextRedStyle,
                  ),
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
    Map<String, double> eventGeoPoint = widget.event.coordinates;
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
                isInGeoPointArea = await checkInGeoPointArea(eventGeoPoint);
                if (isInGeoPointArea) {
                  if (mounted) {
                    setState(() {
                      _userAttending = !_userAttending;
                      addParticipant(widget.event.id);
                    });
                  }
                  _close();
                } else {
                  _showSnackBar("You are not in the area");
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _close() {
    Navigator.of(context).pop();
  }
}
