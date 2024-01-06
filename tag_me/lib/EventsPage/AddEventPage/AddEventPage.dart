
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tag_me/EventsPage/EventsPage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class AddEventForm extends StatefulWidget {
  final List<Event> intialEvents;

  const AddEventForm({Key? key, required this.intialEvents}) : super(key: key);

  @override
  _AddEventFormState createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  final TextEditingController _participantsController = TextEditingController();

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
              decoration: InputDecoration(labelText: 'Event Name'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            Row(
              children: [
                Text('Start Time: ${DateFormat('yyyy-MM-dd HH:mm').format(_startTime)}'),
                IconButton(
                  icon: Icon(Icons.event),
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
                Text('End Time: ${DateFormat('yyyy-MM-dd HH:mm').format(_endTime)}'),
                IconButton(
                  icon: Icon(Icons.event),
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
              decoration: InputDecoration(labelText: 'Participants'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _onSubmit();
              },
              child: const Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }

void _onSubmit() async {
  if (_nameController.text.isEmpty ||
      _participantsController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill in all required fields')),
    );
    return;
  }

  String location = await _getLocation();

  final newEvent = Event(
    name: _nameController.text,
    startTime: _startTime,
    endTime: _endTime,
    location: location,
    isParticipating: false,
  );

  widget.intialEvents.add(newEvent);

  Navigator.pop(context);
}


  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _participantsController.dispose();
    super.dispose();
  }
}

Future<String> _getLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    return placemarks[0].name ?? "Unknown Location";
  } catch (e) {
    return "Error getting location";
  }
}

