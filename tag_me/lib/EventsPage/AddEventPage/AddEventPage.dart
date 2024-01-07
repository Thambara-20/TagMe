// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:tag_me/EventsPage/EventsPage.dart';
import 'package:tag_me/Map/Map.dart';
import 'package:geocoding/geocoding.dart';


class AddEventForm extends StatefulWidget {
  final List<Event> initialEvents;

  const AddEventForm({Key? key, required this.initialEvents}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddEventFormState createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final TextEditingController _nameController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  final TextEditingController _participantsController = TextEditingController();
  String _location = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectLocation,
              child: const Text('Select Location'),
            ),
            const SizedBox(height: 10),
            Text('Selected Location: $_location'),
            const SizedBox(height: 10),
           Row(
              children: [
                Text(
                    'Start Time: ${DateFormat('yyyy-MM-dd HH:mm').format(_startTime)}'),
                IconButton(
                  icon: const Icon(Icons.event),
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _startTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      // ignore: use_build_context_synchronously
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_startTime),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _startTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                        });
                      }
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text(
                    'End Time: ${DateFormat('yyyy-MM-dd HH:mm').format(_endTime)}'),
                IconButton(
                  icon: const Icon(Icons.event),
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _endTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      // ignore: use_build_context_synchronously
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_endTime),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _endTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                        });
                      }
                    }
                  },
                ),
              ],
            ),
            TextField(
              controller: _participantsController,
              decoration: const InputDecoration(labelText: 'Participants'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onSubmit,
              child: const Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }

Future<void> _selectLocation() async {
  GeoPoint selectedPoint = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MapWidget()),
  );

  List<Placemark> placemarks = await placemarkFromCoordinates(
    selectedPoint.latitude,
    selectedPoint.longitude,
  );

  if (placemarks.isNotEmpty) {
    Placemark placemark = placemarks[0];
    String town = placemark.locality ?? 'Unknown Town';
    
    setState(() {
      _location = 'Town: $town';
    });
  }
}

  void _onSubmit() async {
    if (_nameController.text.isEmpty ||
        _location.isEmpty ||
        _participantsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    // Create the Event object
    Event newEvent = Event(
      name: _nameController.text,
      location: _location,
      startTime: _startTime,
      endTime: _endTime, 
      isParticipating: false,

    );

    setState(() {
      widget.initialEvents.add(newEvent);
    });


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event added successfully')),
    );

    // Clear the form
    _nameController.clear();
    _participantsController.clear();
    setState(() {
      _startTime = DateTime.now();
      _endTime = DateTime.now();
      _location = '';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _participantsController.dispose();
    super.dispose();
  }
}
