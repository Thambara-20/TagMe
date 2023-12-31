// ignore: file_names
import 'package:flutter/material.dart';
import 'package:tag_me/constants/constants.dart';

class Event {
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final int participants;
  final bool userAttending;
  final String location;

  Event({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.participants,
    required this.userAttending,
    required this.location,
  });
}

class EventBox extends StatefulWidget {
  final Event event;

  const EventBox({Key? key, required this.event}) : super(key: key);

  @override
  _EventBoxState createState() => _EventBoxState();
}

class _EventBoxState extends State<EventBox> {
  bool _userAttending = false;

  @override
  void initState() {
    super.initState();
    _userAttending = widget.event.userAttending;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.black,
      child: ListTile(
        title: Center(
          child: Text(
            widget.event.name,
            style: klargeTextWhiteStyle,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Start Time:',
                _formatDateTime(widget.event.startTime), Icons.access_time),
            _buildDetailRow('End Time:', _formatDateTime(widget.event.endTime),
                Icons.access_time),
            _buildDetailRow(
                'Participants:', '${widget.event.participants}', Icons.people),
            _buildDetailRow(
                'Location:', '${widget.event.location}', Icons.location_on),
            _buildDetailRow(
                'User Attending:', widget.event.userAttending, Icons.person),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                _verifyAttendance();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _userAttending ? Colors.green : Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              child: Center(
                child: Text(
                  _userAttending ? 'Attendance Marked' : 'Mark Attendance Now',
                  style: knormalTextWhiteStyle,
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
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 8.0),
          if (label == 'User Attending:')
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$label ',
                    style: knormalTextWhiteStyle,
                  ),
                  Text(
                    _userAttending ? 'Yes' : 'No',
                    style: TextStyle(
                      color: _userAttending ? Colors.green : Colors.red,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Text(
                '$label $value',
                style: knormalTextWhiteStyle,
              ),
            ),
        ],
      ),
    );
  }

  void _verifyAttendance() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_userAttending ? 'Warning' : 'Verify Attendance'),
          content: _userAttending
              ?const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'You have already marked your attendance. Pressing again will switch to "No".',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                )
              : const Text(
                  'Please provide the required verification to mark your attendance.'),
          actions: [
            TextButton(
              onPressed: () {
                // Add logic for successful verification.
                setState(() {
                  _userAttending = !_userAttending; // Toggle attendance status.
                });
                Navigator.of(context).pop();
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}
