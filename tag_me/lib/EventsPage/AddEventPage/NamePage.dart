import 'package:flutter/material.dart';
import 'package:tag_me/utilities/event.dart';

class NamePage extends StatelessWidget {
  final TextEditingController nameController;
  final VoidCallback onNext;
  final Event event;

  NamePage({
    required this.nameController,
    required this.event,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Event Name'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double
                  .infinity, // Use double.infinity to make it take the full width
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  onNext();
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
