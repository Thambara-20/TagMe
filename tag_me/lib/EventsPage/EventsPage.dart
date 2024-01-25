// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tag_me/EventsPage/AddEventPage/AddEventPage.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/utilities/cache.dart';
import 'package:tag_me/utilities/event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  static const String routeName = '/EventsPage';

  @override
  // ignore: library_private_types_in_public_api
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Event> events = [];
  List<Event> searchResult = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _listenToEvents();
  }

  void _listenToEvents() {
    FirebaseFirestore.instance.collection('events').snapshots().listen((snapshot) {
      setState(() {
        events = snapshot.docs.map((document) {
          Map<String, dynamic> data = document.data();

          return Event(
            id: document.id,
            creator: data['creator'] ?? '',
            name: data['name'] ?? '',
            startTime: (data['startTime'] as Timestamp).toDate(),
            endTime: (data['endTime'] as Timestamp).toDate(),
            location: data['location'] ?? '',
            geoPoint: List<double>.from(
              (data['geoPoint'] as List<dynamic>?)?.cast<double>() ?? [],
            ),
            coordinates: Map<String, double>.from(data['coordinates'] ?? {}),
            participants: List<String>.from(
              (data['participants'] as List<dynamic>?)?.cast<String>() ?? [],
            ),
            isParticipating: data['isParticipating'] ?? false,
          );
        }).toList();

        searchResult = events.where((event) {
          return event.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
        }).toList();
        if (events.isNotEmpty) {
          isLoading = false;
          
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: khomePageBackgroundColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchResult = events.where((event) {
                      return event.name
                          .toLowerCase()
                          .contains(value.toLowerCase());
                    }).toList();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Events',
                  filled: true,
                  fillColor: ksearchBarColor,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: searchResult.length,
                      itemBuilder: (context, index) {
                        return _buildEventListItem(searchResult[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onCreateEvent(context);
        },
        backgroundColor: kAddButtonColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventListItem(Event event) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      color: keventCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: const BorderSide(
          color: keventCardBorderColor,
          width: 0.5,
        ),
      ),
      child: ListTile(
        title: Center(
          child: Column(
            children: [
              Text(
                event.name,
                style: const TextStyle(fontSize: 18.0),
              ),
              Text(
                'Start Time: ${_formatDateTime(event.startTime)}',
                style: const TextStyle(fontSize: 14.0),
              ),
              Text(
                'End Time: ${_formatDateTime(event.endTime)}',
                style: const TextStyle(fontSize: 14.0),
              ),
              Text(
                'Location: ${event.location}',
                style: const TextStyle(fontSize: 14.0),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    event.isParticipating = true;
                  });
                },
                child: Text(event.isParticipating
                    ? 'Already Participated'
                    : 'Participate'),
              ),
            ],
          ),
        ),
        onTap: () {
          _onEventTapped(context, event);
        },
      ),
    );
  }

  void _onEventTapped(BuildContext context, Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventForm(
          initialEvents: events,
          selectedEvent: event,
        ),
      ),
    );

  }

  void _onCreateEvent(BuildContext context) async {
    final newEvent = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventForm(initialEvents: events),
      ),
    );
    saveEventsToCache(events);

    if (newEvent != null) {
      setState(() {
        events.add(newEvent);
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
