// ignore_for_file: file_names

import 'dart:convert'; // Import for JSON decoding
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:tag_me/HomePage/EventBox/EventBox.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/models/event.dart';
import 'package:tag_me/utilities/cache.dart';

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
    cachedEvents = await loadOngoingEventsFromCache();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 0, 0, 0),
          khomePageBackgroundColor
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
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
