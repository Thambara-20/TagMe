import 'package:flutter/material.dart';
import 'package:tag_me/constants/constants.dart';

class Event {
  final String name;
  final DateTime startTime;
  final String location;

  Event({
    required this.name,
    required this.startTime,
    required this.location,
  });
}

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  static const String routeName = '/EventsPage';

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  TextEditingController _searchController = TextEditingController();
  List<Event> events = List.generate(
    10,
        (index) => Event(
      name: 'Event $index',
      startTime: DateTime.now().add(Duration(days: index)),
      location: 'Location $index',
    ),
  );

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
                    // Filter events based on the search query
                    events = List.generate(
                      10,
                          (index) => Event(
                        name: 'Event $index',
                        startTime: DateTime.now().add(Duration(days: index)),
                        location: 'Location $index',
                      ),
                    ).where(
                          (event) =>
                      event.name.toLowerCase().contains(value.toLowerCase()) ||
                          event.location.toLowerCase().contains(value.toLowerCase()),
                    ).toList();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Events',
                  filled: true,
                  fillColor: Colors.white,
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
                  return _buildEventListItem(events[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle creating a new event
          _onCreateEvent(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventListItem(Event event) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      color: Colors.white, // Replace with your desired background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: const BorderSide(
          color: Colors.black,
          width: 0.5,
        ),
      ),
      child: ListTile(
        title: Center(
          child: Column(
            children: [
              Text(
                event.name,
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Start Time: ${_formatDateTime(event.startTime)}',
                style: TextStyle(fontSize: 14.0),
              ),
              Text(
                'Location: ${event.location}',
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ),
        onTap: () {
          _onEventTapped(context, event.name);
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Create Event tapped')),
    );
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
