// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tag_me/EventsPage/AddEventPage/DateTimePicker.dart';
import 'package:tag_me/utilities/Location.dart';
import 'package:tag_me/utilities/comfirmationDialog.dart';
import 'package:tag_me/utilities/event.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/utilities/eventFunctions.dart';

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
  String _id = '';
  String _location = '';
  List<double> _geoPoint = [];
  Map<String, double> _coordinates = {
    "latitude": 6.927079,
    "longtitude": 79.861
  };
  List<String> _participants = ["user"];
  @override
  void initState() {
    super.initState();

    if (widget.selectedEvent != null) {
      _id = widget.selectedEvent!.id;
      _nameController.text = widget.selectedEvent!.name;
      _startTime = widget.selectedEvent!.startTime;
      _endTime = widget.selectedEvent!.endTime;
      _participants = widget.selectedEvent!.participants;
      _location = widget.selectedEvent!.location;
      _geoPoint = widget.selectedEvent!.geoPoint;
      _coordinates = widget.selectedEvent!.coordinates;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
        actions: [
          if (widget.selectedEvent != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _onDelete();
              },
            ),
        ],
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
                if (!mounted) {
                  return;
                }
                try {
                  Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  // ignore: use_build_context_synchronously
                  var p = await showSimplePickerLocation(
                    context: context,
                    isDismissible: true,
                    title: "Select the location",
                    textConfirmPicker: "pick",
                    zoomOption: const ZoomOption(
                      initZoom: 8,
                    ),
                    initPosition: await getGeoPointFromLocation(_coordinates),
                    radius: 10,
                  );
                  List<Placemark> placemarks = [];
                  if (p != null) {
                    placemarks =
                        await placemarkFromCoordinates(p.latitude, p.longitude);
                    setState(() {
                      _coordinates["latitude"] = p.latitude;
                      _coordinates["longtitude"] = p.longitude;
                    });
                  } else {
                    placemarks = await placemarkFromCoordinates(
                        position.latitude, position.longitude);
                  }
                  Placemark placemark = placemarks[0];
                  String town = placemark.locality ?? 'Unknown Town';

                  setState(() {
                    _location = town;
                  });
                  // ignore: empty_catches
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Failed to get current location')),
                    );
                  }
                }
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

  void _onDelete() {
    // Add logic to delete the event
   showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        onConfirm: () {
          // Add logic to delete the event
          if (widget.selectedEvent != null) {
            deleteEvent(widget.selectedEvent!.id);
            Navigator.pop(context); 
          }
        },
        confirmationMessage: 'Are you sure you want to delete this event?',
      );
    },
  );
  }

  void _onSubmit() {
    if (!mounted) {
      return;
    }

    if (_coordinates.isEmpty ||
        _nameController.text.isEmpty ||
        _location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Event newEvent = Event(
          id: _id, // Include id in the constructor
          creator: user.uid,
          name: _nameController.text,
          startTime: _startTime,
          endTime: _endTime,
          location: _location,
          coordinates: _coordinates,
          geoPoint: _geoPoint,
          participants: _participants,
          isParticipating: false,
        );
        if (_id.isNotEmpty) {
          updateEvent(newEvent);
        } else {
          addEvent(newEvent);
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event saved successfully')),
        );

        Navigator.pop(context, newEvent);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save event')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
