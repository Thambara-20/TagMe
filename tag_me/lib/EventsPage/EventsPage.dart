// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:tag_me/EventsPage/AddEventPage/AddEventPage.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/utilities/authService.dart';
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
  bool isAddmin = false;

  @override
  initState() {
    super.initState();
    _listenToEvents();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    User? user = FirebaseAuth.instance.currentUser;
    isAddmin = await FirebaseAuthService().isUserAdmin(user!.uid);
  }

  void _listenToEvents() {
   loadEventsFromCache().then((loadedEvents) {
      setState(() {
        events = loadedEvents;
        searchResult = events;
        isLoading = false;
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
                  ? const Center(
                      child: Text(
                        'No events available.',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
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
          isAddmin ? _onCreateEvent(context) : null;
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
                style: const TextStyle(fontSize: 15.0),
              ),
              Text(
                'End Time: ${_formatDateTime(event.endTime)}',
                style: const TextStyle(fontSize: 15.0),
              ),
              Text(
                'Location: ${event.location}',
                style: const TextStyle(fontSize: 15.0),
              ),
              CountdownTimer(
                endTime: event.startTime.millisecondsSinceEpoch,
                textStyle: const TextStyle(
                    fontSize: 15.0, color: Color.fromARGB(255, 185, 12, 0)),
              ),
            ],
          ),
        ),
        onTap: () {
          isAddmin ? _onEventTapped(context, event) : null;
        },
      ),
    );
  }

  void _onEventTapped(BuildContext context, Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventForm(
          selectedEvent: event,
        ),
      ),
    );
  }

  void _onCreateEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEventForm(),
      ),
    );
    saveEventsToCache(events);
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
