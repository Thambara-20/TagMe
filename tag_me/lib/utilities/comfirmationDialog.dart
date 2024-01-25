// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String confirmationMessage;

  const ConfirmationDialog({
    Key? key,
    required this.onConfirm,
    required this.confirmationMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Action'),
      content:  Text(confirmationMessage),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onConfirm(); // Trigger the callback
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
