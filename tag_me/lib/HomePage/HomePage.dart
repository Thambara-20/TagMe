// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tag_me/HomePage/EventBox/EventBox.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/models/event.dart';
import 'package:tag_me/models/user.dart';
import 'package:tag_me/utilities/cache.dart';
import 'package:tag_me/utilities/userServices.dart';
// ... (existing imports)

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/HomePage';

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Event> cachedEvents = [];
  late String selectedClub;
  List<String> clubs = [
    'Leo District 306A1',
    'Leo District 306A2',
    'Leo District 306B1',
    'Leo District 306B2',
    'Leo District 306C1',
    'Leo District 306C2'
  ];

  @override
  void initState() {
    super.initState();
    loadUser();
    loadEventsFromCache();
    selectedClub = clubs[0];
  }

  Future<void> loadUser() async {
    Prospect prospect = await getUserInfo();
    
    setState(() {
      selectedClub = prospect.userClub;
    });
  }

  Future<void> loadEventsFromCache() async {
    Prospect prospect = await getUserInfo();
    if (prospect.userClub == '' || prospect.userClub.isEmpty) {
      _showEditProfileNotification(context);
    } else {
      cachedEvents = await loadOngoingEventsFromCache(selectedClub);
      setState(() {});
    }
  }

  void _showEditProfileNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please Edit Your Profile'),
          content: const Text('You need to set your profile to view events.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refresh() async {
    await loadEventsFromCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 0, 0),
                khomePageBackgroundColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('select your district: ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 147, 147, 147),
                            fontSize: 16)),
                    _buildClubDropdown(),
                  ],
                ),
              ),
              Expanded(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClubDropdown() {
    return DropdownButton<String>(
      value: selectedClub,
      onChanged: (String? newValue) {
        setState(() {
          selectedClub = newValue!;
        });
        _refresh();
      },
      items: clubs.map((String club) {
        return DropdownMenuItem<String>(
          value: club,
          child: Text(
            club,
            style: const TextStyle(
              color: Color.fromARGB(255, 147, 147, 147),
            ),
          ),
        );
      }).toList(),
    );
  }
}
