import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tag_me/EventsPage/AddEventPage/DateTimePicker.dart';
import 'package:tag_me/utilities/event.dart';
import 'package:tag_me/utilities/Location.dart';
import 'package:tag_me/constants/constants.dart';

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
  List<double> _geoPoint = [];
  List<String> _participants = ["user"]; 
  @override
  void initState() {
    super.initState();

    if (widget.selectedEvent != null) {
      _nameController.text = widget.selectedEvent!.name;
      _startTime = widget.selectedEvent!.startTime;
      _endTime = widget.selectedEvent!.endTime;
      _participants = widget.selectedEvent!.participants;
      _location = widget.selectedEvent!.location;
      _geoPoint = widget.selectedEvent!.geoPoint;
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
              onPressed: () async {
                try {
                  Position position = await determinePosition();
                  // ignore: use_build_context_synchronously
                  var p = await showSimplePickerLocation(
                    context: context,
                    isDismissible: true,
                    title: "Select the location",
                    textConfirmPicker: "pick",
                    zoomOption: const ZoomOption(
                      initZoom: 8,
                    ),
                    initPosition: GeoPoint(
                      latitude: _geoPoint.isEmpty ? 6.9271 : _geoPoint[0],
                      longitude: _geoPoint.isEmpty ? 79.861 : _geoPoint[1],
                    ),
                    radius: 10,
                  );
                  List<Placemark> placemarks = [];
                  if (p != null) {
                    placemarks =
                        await placemarkFromCoordinates(p.latitude, p.longitude);
                    setState(() {
                      _geoPoint.add(p.latitude);
                      _geoPoint.add(p.longitude);
                    });
                  } else {
                    placemarks = await placemarkFromCoordinates(
                        position.latitude, position.longitude);
                    _geoPoint.add(position.latitude);
                    _geoPoint.add(position.longitude);
                  }
                  Placemark placemark = placemarks[0];
                  String town = placemark.locality ?? 'Unknown Town';

                  setState(() {
                    _location = '$town';
                  });
                } catch (e) {}
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Select Location',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Location: ', style: knormalTextBlackStyle),
                Text(_location, style: knormalTextBlueStyle),
                //latitude and longtitude show
                const SizedBox(width: 10)
              ],
            ),
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
                  onPressed:
                      (_location.isNotEmpty && _nameController.text.isNotEmpty)
                          ? _onSubmit
                          : null,
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

  void _onSubmit() async {
    if (_geoPoint.isEmpty ||
        _nameController.text.isEmpty ||
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
        geoPoint: _geoPoint,
        participants: _participants,
        isParticipating: false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event saved successfully')),
    );

    Navigator.pop(context, newEvent);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
