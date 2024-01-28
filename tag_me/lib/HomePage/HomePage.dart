import 'dart:convert'; // Import for JSON decoding
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:tag_me/HomePage/EventBox/EventBox.dart';
import 'package:tag_me/models/event.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/HomePage';

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Event> cachedEvents = [];

  @override
  void initState() {
    super.initState();
    loadEventsFromCache();
  }

  Future<void> loadEventsFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString("events");
    if (eventsJson != null) {
      final List<dynamic> decoded = json.decode(eventsJson);
      cachedEvents = decoded.map((eventJson) => Event.fromJson(eventJson)).toList();
    }

    setState(() {}); // Trigger a rebuild after loading events from cache
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_home.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: cachedEvents.isNotEmpty
            ? ListView.builder(
                itemCount: cachedEvents.length,
                itemBuilder: (context, index) {
                  return EventBox(event: cachedEvents[index]);
                },
              )
            : const Center(
                child: Text(
                  'No ongoing events available.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
