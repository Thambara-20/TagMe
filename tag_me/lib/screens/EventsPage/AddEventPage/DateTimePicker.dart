// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  final String text;
  final DateTime initialDateTime;
  final Function(DateTime) onDateTimeChanged;

  const DateTimePicker({
    Key? key,
    required this.text,
    required this.initialDateTime,
    required this.onDateTimeChanged,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  Future<void> _selectDateTime(BuildContext context) async {
    try {
      final selectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );

      if (selectedDate != null) {
        // ignore: use_build_context_synchronously
        final selectedTime = await showTimePicker(
          // ignore: use_build_context_synchronously
          context: context,
          initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
        );

        if (selectedTime != null) {
          setState(() {
            _selectedDateTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );
          });
          widget.onDateTimeChanged(_selectedDateTime);
        }
      }
    }
    // ignore: empty_catches
    catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${widget.text}: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime)}',
        ),
        IconButton(
          icon: const Icon(Icons.event),
          onPressed: () => _selectDateTime(context),
        ),
      ],
    );
  }
}
