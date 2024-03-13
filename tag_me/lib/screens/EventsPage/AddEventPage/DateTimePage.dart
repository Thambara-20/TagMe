import 'package:flutter/material.dart';
import 'package:tag_me/screens/EventsPage/AddEventPage/DateTimePicker.dart';

import '../../../models/event.dart';

class DateTimePage extends StatelessWidget {
  final Event event;
  final VoidCallback onBack;
  final VoidCallback onSave;

  DateTimePage({
    Key? key,
    required this.event,
    required this.onBack,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    DateTimePicker(
                      text: "Start Time",
                      initialDateTime: event.startTime,
                      onDateTimeChanged: (newDateTime) {
                        // Update start time
                        event.startTime = newDateTime;
                        // Automatically update end time to midnight of the same day
                        event.endTime = DateTime(
                          newDateTime.year,
                          newDateTime.month,
                          newDateTime.day,
                        ).add(Duration(days: 1)); // Add one day to set to midnight of the next day
                      },
                    ),
                    const SizedBox(height: 20),
                    DateTimePicker(
                      text: "End Time",
                      initialDateTime: event.endTime,
                      onDateTimeChanged: (newDateTime) {
                        // Update end time
                        event.endTime = newDateTime;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onBack,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSave,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
