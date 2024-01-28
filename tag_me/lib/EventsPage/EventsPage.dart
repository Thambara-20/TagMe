// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:tag_me/EventsPage/AddEventPage/AddEventPage.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/models/user.dart';
import 'package:tag_me/utilities/cache.dart';
import 'package:tag_me/models/event.dart';
import 'package:tag_me/utilities/dateConvert.dart';

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
  late AppUser user;

  @override
  initState() {
    super.initState();
    _listenToEvents();
    _getUserInfo();
  }

  void _listenToEvents() {
    Future.delayed(const Duration(seconds: 1), () {
      loadEventsFromCache().then((loadedEvents) {
        setState(() {
          events = loadedEvents;
          searchResult = events;
          isLoading = false;
        });
      });
    });
  }

  void _getUserInfo() {
    getLoggedInUserInfo().then((loggedInUser) {
      setState(() {
        user = loggedInUser;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          user.isAdmin ? _onCreateEvent(context) : null;
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
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(
          color: keventCardBorderColor,
          width: 0.5,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          'Project: ${event.name}',
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Starts At: ${formatDateTime(event.startTime)}',
          style: const TextStyle(fontSize: 16.0),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'End Time: ${formatDateTime(event.endTime)}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                Center(
                  child: Text(
                    'Location: ${event.location}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(height: 2.0),
                Center(
                  child: CountdownTimer(
                    endTime: event.startTime.millisecondsSinceEpoch,
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 185, 12, 0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (user.isAdmin)
                      ElevatedButton(
                          onPressed: () {
                            _onEventTapped(context, event);
                          },
                          child: const Text('Update')),
                  ],
                ),
              ],
            ),
          ),
        ],
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

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));

    loadEventsFromCache().then((loadedEvents) {
      setState(() {
        events = loadedEvents;
        searchResult = events;
      });
    });
  }
}
