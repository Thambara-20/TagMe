import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tag_me/EventsPage/AddEventPage/DateTimePicker.dart';
import 'package:tag_me/utilities/event.dart';
import 'package:tag_me/Map/Map.dart';
import 'package:tag_me/utilities/Location.dart';

class AddEventForm extends StatefulWidget {
  final List<Event> initialEvents;
  final Event? selectedEvent;

  const AddEventForm({
    Key? key,
    required this.initialEvents,
    this.selectedEvent,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddEventFormState createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final TextEditingController _nameController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  String _location = '';
  List<String> _participants = ["user"]; // List of participants

  @override
  void initState() {
    super.initState();

    if (widget.selectedEvent != null) {
      _nameController.text = widget.selectedEvent!.name;
      _startTime = widget.selectedEvent!.startTime;
      _endTime = widget.selectedEvent!.endTime;
      _participants = widget.selectedEvent!.participants;
      _location = widget.selectedEvent!.location;
    }
  }

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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Select Location',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            Text('Selected Location: $_location'),
            const SizedBox(height: 10),
            DateTimePicker(
              initialDateTime: _startTime,
              onDateTimeChanged: (newDateTime) {
                setState(() {
                  _startTime = newDateTime;
                });
              },
            ),
            DateTimePicker(
              initialDateTime: _endTime,
              onDateTimeChanged: (newDateTime) {
                setState(() {
                  _endTime = newDateTime;
                });
              },
            ),
            //line of black
            const Divider(
              color: Colors.black,
              thickness: 1.0,
              height: 20.0,
            ),

            DataTable(
              columns: const [
                DataColumn(label: Text('Participants')),
              ],
              rows: _participants.map<DataRow>((participant) {
                return DataRow(
                  cells: [
                    DataCell(Text(participant)),
                  ],
                );
              }).toList(),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  
                  onPressed: (_location.isNotEmpty && _nameController.text.isNotEmpty )?  _onSubmit : null,
                  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Save Event',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectLocation() async {
    try {
      GeoPoint? selectedPoint = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MapWidget()),
      );
      List<Placemark> placemarks = [];
      if (selectedPoint != null) {
        placemarks = await placemarkFromCoordinates(
            selectedPoint.latitude, selectedPoint.longitude);
      } else {
        Position position = await determinePosition();
        placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
      }
      Placemark placemark = placemarks[0];
      String town = placemark.locality ?? 'Unknown Town';

      setState(() {
        _location = 'Town: $town';
      });
    } catch (e) {
      _close();
    }
  }

  void _onSubmit() async {
    if (_nameController.text.isEmpty ||
        _location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
    }

    Event newEvent = Event(
      creator: 'User',
      name: _nameController.text,
      startTime: _startTime,
      endTime: _endTime,
      location: _location,
      participants: _participants,
      isParticipating: false
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event saved successfully')),
    );

    Navigator.pop(context, newEvent);
  }

  void _close() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
