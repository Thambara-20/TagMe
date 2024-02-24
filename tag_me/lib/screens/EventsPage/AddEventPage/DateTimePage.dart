// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:tag_me/screens/EventsPage/AddEventPage/DateTimePicker.dart';

import '../../../models/event.dart';

class DateTimePage extends StatelessWidget {
  Event event;
  VoidCallback onBack;
  VoidCallback onSave;

  DateTimePage({
    super.key,
    required this.event,
    required this.onBack,
    required this.onSave,
  });

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
                      text:"Start Time",
                      initialDateTime: event.startTime,
                      onDateTimeChanged: (newDateTime) {
                        event.startTime = newDateTime;
                      },
                    ),
                    const SizedBox(height: 20),
                    DateTimePicker(
                      text:"End Time",
                      initialDateTime: event.endTime,
                      onDateTimeChanged: (newDateTime) {
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
                    onPressed: () {
                      onBack();
                    },
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onSave();
                    },
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
