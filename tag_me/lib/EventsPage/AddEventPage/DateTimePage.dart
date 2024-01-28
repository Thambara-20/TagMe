// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tag_me/EventsPage/AddEventPage/DateTimePicker.dart';

import '../../models/event.dart';

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
                      initialDateTime: event.startTime,
                      onDateTimeChanged: (newDateTime) {
                        event.startTime = newDateTime;
                        // Handle the change
                      },
                    ),
                    const SizedBox(height: 20),
                    DateTimePicker(
                      initialDateTime: event.endTime,
                      onDateTimeChanged: (newDateTime) {
                        event.endTime = newDateTime;
                        // Handle the change
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
