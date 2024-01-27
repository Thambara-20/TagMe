// // ignore_for_file: file_names
// import 'package:firebase_auth/firebase_aort 'package:flutter/material.dart';
// import 'p:flutter_osm_plugin/flutter_osm_plugin.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:tag_me/EventsPage/AddEventPage/DateTimePicker.dart';
// import 'package:tag_me/utilities/Location.dart';
// import 'package:tag_me/utilities/comfirmationDialog.dart';
// import 'package:tag_me/utilities/event.dart';
// import 'package:tag_me/constants/constants.dart';
// import 'package:tag_me/utilities/eventFunctions.dart';

// class AddEventForm extends StatefulWidget {
//   final Event? selectedEvent;

//   const AddEventForm({
//     Key? key,
//     this.selectedEvent,
//   }) : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _AddEventFormState createState() => _AddEventFormState();
// }

// class _AddEventFormState extends State<AddEventForm> {
//   final TextEditingController _nameController = TextEditingController();

//   DateTime _startTime = DateTime.now();
//   DateTime _endTime = DateTime.now();
//   String _id = '';
//   String _location = '';
//   List<double> _geoPoint = [];
//   Map<String, double> _coordinates = {
//     "latitude": 6.927079,
//     "longtitude": 79.861
//   };
//   List<String> _participants = [];

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();

//     if (widget.selectedEvent != null) {
//       _id = widget.selectedEvent!.id;
//       _nameController.text = widget.selectedEvent!.name;
//       _startTime = widget.selectedEvent!.startTime;
//       _endTime = widget.selectedEvent!.endTime;
//       _participants = widget.selectedEvent!.participants;
//       _location = widget.selectedEvent!.location;
//       _geoPoint = widget.selectedEvent!.geoPoint;
//       _coordinates = widget.selectedEvent!.coordinates;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add/Update Event'),
//         actions: [
//           if (widget.selectedEvent != null)
//             IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: () {
//                 _onDelete();
//               },
//             ),
//         ],
//       ),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(labelText: 'Event Name'),
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () async {
//                       if (!mounted) {
//                         Navigator.pop(context);
//                         return;
//                       }
//                       try {
//                         var p = await showSimplePickerLocation(
//                           context: context,
//                           isDismissible: true,
//                           title: "Select the location",
//                           textConfirmPicker: "pick",
//                           zoomOption: const ZoomOption(
//                             initZoom: 8,
//                           ),
//                           initPosition:
//                               await getGeoPointFromLocation(_coordinates),
//                           radius: 10,
//                         );
//                         List<Placemark> placemarks = [];
//                         if (p != null) {
//                           placemarks = await placemarkFromCoordinates(
//                               p.latitude, p.longitude);
//                           _coordinates["latitude"] = p.latitude;
//                           _coordinates["longtitude"] = p.longitude;
//                         } else {
//                           Position position =
//                               await Geolocator.getCurrentPosition(
//                                   desiredAccuracy: LocationAccuracy.high);
//                           placemarks = await placemarkFromCoordinates(
//                               position.latitude, position.longitude);
//                         }
//                         Placemark placemark = placemarks[0];
//                         String town = placemark.locality ?? 'Unknown Town';

//                         _location = town;
//                       } catch (e) {
//                         if (mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content:
//                                     Text('Failed to get current location')),
//                           );
//                         }
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                     ),
//                     child: const Text('Select Location',
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       const Text('Location: ', style: knormalTextBlackStyle),
//                       Text(_location, style: knormalTextBlueStyle),
//                       //latitude and longitude show
//                       const SizedBox(width: 10)
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   DateTimePicker(
//                     initialDateTime: _startTime,
//                     onDateTimeChanged: (newDateTime) {
//                       _startTime = newDateTime;
//                     },
//                   ),
//                   DateTimePicker(
//                     initialDateTime: _endTime,
//                     onDateTimeChanged: (newDateTime) {
//                       _endTime = newDateTime;
//                     },
//                   ),
//                   //line of black
//                   const Divider(
//                     color: Colors.black,
//                     thickness: 1.0,
//                     height: 20.0,
//                   ),

//                   DataTable(
//                     columns: const [
//                       DataColumn(label: Text('Participants')),
//                     ],
//                     rows: _participants.map<DataRow>((participant) {
//                       return DataRow(
//                         cells: [
//                           DataCell(Text(participant)),
//                         ],
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 10),
//                   Align(
//                     alignment: FractionalOffset.bottomCenter,
//                     child: ElevatedButton(
//                       onPressed: (_location.isNotEmpty &&
//                               _nameController.text.isNotEmpty)
//                           ? _onSubmit
//                           : null,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         minimumSize: const Size(double.infinity, 48),
//                       ),
//                       child: const Text('Save Event',
//                           style: TextStyle(color: Colors.white)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _onDelete() {
//     // Add logic to delete the event
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return ConfirmationDialog(
//           onConfirm: () async {
//             // Add logic to delete the event
//             if (widget.selectedEvent != null) {
//               try {
//                 await deleteEvent(widget.selectedEvent!.id);
//                 _exitPage();
//               } catch (e) {
//                 _showError(e);
//               }
//             }
//           },
//           confirmationMessage: 'Are you sure you want to delete this event?',
//         );
//       },
//     );
//   }

//   void _showError(e) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to delete event: $e')),
//       );
//     }
//   }

//   void _onSubmit() {
//     if (!mounted) {
//       return;
//     }

//     if (_coordinates.isEmpty ||
//         _nameController.text.isEmpty ||
//         _location.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill in all required fields')),
//       );
//       return;
//     }

//     try {
//       User? user = FirebaseAuth.instance.currentUser;

//       if (user != null) {
//         Event newEvent = Event(
//           id: _id, // Include id in the constructor
//           creator: user.uid,
//           name: _nameController.text,
//           startTime: _startTime,
//           endTime: _endTime,
//           location: _location,
//           coordinates: _coordinates,
//           geoPoint: _geoPoint,
//           participants: _participants,
//           isParticipating: false,
//         );
//         if (_id.isNotEmpty) {
//           updateEvent(newEvent);
//         } else {
//           addEvent(newEvent);
//         }
//         // ignore: use_build_context_synchronously
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Event saved successfully')),
//         );

//         Navigator.pop(context, newEvent);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to save event')),
//         );
//       }
//     }
//   }
//   void _exitPage() {
//     Navigator.pop(context);
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tag_me/utilities/comfirmationDialog.dart';
import 'package:tag_me/utilities/eventFunctions.dart';
import '../../utilities/event.dart';
import 'NamePage.dart';
import 'LocationPage.dart';
import 'DateTimePage.dart';

class AddEventForm extends StatefulWidget {
  final Event? selectedEvent;

  const AddEventForm({
    Key? key,
    this.selectedEvent,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddEventFormState createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  // ... (rest of your code remains unchanged)

  PageController _pageController = PageController(initialPage: 0);

  final TextEditingController _nameController = TextEditingController();

  var event = Event(
    id: '',
    creator: '',
    name: '',
    startTime:DateTime.now() ,
    endTime: DateTime.now(),
    location: '',
    geoPoint: [],
    coordinates: {
    "latitude": 6.927079,
    "longtitude": 79.861},
    participants: [],
    isParticipating: false,
  );

  @override
  void initState() {
    super.initState();

    if (widget.selectedEvent != null) {
      event.id = widget.selectedEvent!.id;
      _nameController.text = widget.selectedEvent!.name;
      event.startTime = widget.selectedEvent!.startTime;
      event.endTime = widget.selectedEvent!.endTime;
      event.participants = widget.selectedEvent!.participants;
      event.location = widget.selectedEvent!.location;
      event.geoPoint = widget.selectedEvent!.geoPoint;
      event.coordinates = widget.selectedEvent!.coordinates;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Update Event'),
        actions: [
          if (widget.selectedEvent != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _onDelete();
              },
            ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          NamePage(
            event: event,
            nameController: _nameController,
            onNext: () {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
          ),
          LocationPage(
            event: event,
            onBack: () {
              _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            onNext: () {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
          ),
          DateTimePage(
            event: event,
            onBack: () {
              _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            onSave: () {
              _onSubmit();
            },
          ),
        ],
      ),
    );
  }

  void _onDelete() {
    // Add logic to delete the event
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          onConfirm: () async {
            // Add logic to delete the event
            if (widget.selectedEvent != null) {
              try {
                await deleteEvent(widget.selectedEvent!.id);
                _exitPage();
              } catch (e) {
                _showError(e);
              }
            }
          },
          confirmationMessage: 'Are you sure you want to delete this event?',
        );
      },
    );
  }

  void _showError(e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event: $e')),
      );
    }
  }

  void _onSubmit() {
    print(event.coordinates);
    print(event.location);
    print(_nameController.text);
    print(event.startTime);
    if (!mounted) {
      return;
    }

    if (event.coordinates.isEmpty ||
        _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Event newEvent = Event(
          id: event.id, // Include id in the constructor
          creator: user.uid,
          name: event.name,
          startTime: event.startTime,
          endTime: event.endTime,
          location: event.location,
          coordinates: event.coordinates,
          geoPoint: event.geoPoint,
          participants: event.participants,
          isParticipating: false,
        );
        if (event.id.isNotEmpty) {
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

  void _exitPage() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
