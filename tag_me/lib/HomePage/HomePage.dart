import 'package:flutter/material.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/HomePage/EventBox/EventBox.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Event> ongoingEvents = [
    Event(
      name: 'Event 1',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: 2)),
      participants: 20,
      userAttending: true,
      location: 'Location 1',
    ),
    Event(
      name: 'Event 2',
      startTime: DateTime.now().add(Duration(days: 1)),
      endTime: DateTime.now().add(Duration(days: 1, hours: 3)),
      participants: 15,
      userAttending: false,
      location: 'Location 2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ongoing Events', style: klargeTextWhiteStyle),
        backgroundColor: Colors.black,
         leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ktextColorWhite),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        
      ),
      body: ListView.builder(
        itemCount: ongoingEvents.length,
        itemBuilder: (context, index) {
          return EventBox(event: ongoingEvents[index]);
        },
      ),
    );
  }
}
