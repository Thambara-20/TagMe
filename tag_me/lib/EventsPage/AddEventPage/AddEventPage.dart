// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tag_me/utilities/comfirmationDialog.dart';
import 'package:tag_me/utilities/eventServices.dart';
import 'package:tag_me/utilities/userServices.dart';
import '../../models/event.dart';
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
  final PageController _pageController = PageController(initialPage: 0);

  final TextEditingController _nameController = TextEditingController();
  late String district;
  var event = Event(
    id: '',
    creator: '',
    name: '',
    district: '',
    startTime: DateTime.now(),
    endTime: DateTime.now(),
    location: '',
    geoPoint: [],
    coordinates: {"latitude": 6.927079, "longtitude": 79.861},
    participants: [],
    isParticipating: false,
  );

  @override
  void initState() {
    super.initState();
    getClub();


    if (widget.selectedEvent != null) {
      event.id = widget.selectedEvent!.id;
      _nameController.text = widget.selectedEvent!.name;
      event.startTime = widget.selectedEvent!.startTime;
      event.district = widget.selectedEvent!.district;
      event.endTime = widget.selectedEvent!.endTime;
      event.participants = widget.selectedEvent!.participants;
      event.location = widget.selectedEvent!.location;
      event.geoPoint = widget.selectedEvent!.geoPoint;
      event.coordinates = widget.selectedEvent!.coordinates;
    }
  }

  void getClub() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      event.district = await findAdminDistrict(user.uid);
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
        physics: const NeverScrollableScrollPhysics(),
        children: [
          NamePage(
            event: event,
            nameController: _nameController,
            onNext: () {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
          ),
          LocationPage(
            event: event,
            onBack: () {
              _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            onNext: () {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
          ),
          DateTimePage(
            event: event,
            onBack: () {
              _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
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
    if (!mounted) {
      return;
    }

    if (event.coordinates.isEmpty ||
        _nameController.text.isEmpty ||
        event.location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Event newEvent = Event(
          id: event.id, 
          creator: user.uid,
          name: _nameController.text,
          district: event.district,
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

        Navigator.pop(context);
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
