// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tag_me/EventsPage/AddEventPage/AddEventPage.dart';
import 'package:tag_me/constants/constants.dart';

class Event {
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  bool isParticipating;

  Event({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.isParticipating,
  });
}

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
                    events = events.where((event) {
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
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  if (events[index].isParticipating == false ){
                  return _buildEventListItem(events[index]);

                  }
                  return null;
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
              child: Text(event.isParticipating ? 'Already Participated' : 'Participate'),
            ),
          ],
        ),
      ),
      onTap: () {
        _onEventTapped(context, event.name);
        setState(() {
        });
      },
    ),
  );
}


  void _onEventTapped(BuildContext context, String eventName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tapped on $eventName')),
    );
  }

  void _onCreateEvent(BuildContext context) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddEventForm(initialEvents: events)))
        .then((value) => {
              {setState(() {})}
            });
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