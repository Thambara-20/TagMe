// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tag_me/HomePage/EventBox/EventBox.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/models/event.dart';
import 'package:tag_me/models/user.dart';
import 'package:tag_me/utilities/cache.dart';
import 'package:tag_me/utilities/userServices.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/HomePage';

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Event> cachedEvents = [];
  late String selectedDistrict;
  List<String> districts = [];

  @override
  void initState() {
    super.initState();
    selectedDistrict = '';
    loadData();
  }

  Future<void> loadUser() async {
    Prospect prospect = await getUserInfo();
    setState(() {
      selectedDistrict =
          prospect.district != '' ? prospect.district : districts[0];
    });
  }

  Future<void> loadData() async {
    districts = await loadDistrictsFromCache();
    await loadUser();
    await loadEventsFromCache();
  }

  Future<void> loadEventsFromCache() async {
    Prospect prospect = await getUserInfo();
    if (prospect.district == '' || prospect.district.isEmpty) {
      _showEditProfileNotification(context);
    } else {
      cachedEvents = await loadOngoingEventsFromCache(selectedDistrict);
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
      body: FutureBuilder(
          future: loadDistrictsFromCache(),
          builder: (context, snapshot) {
            if (selectedDistrict.isEmpty) {
              return Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else {
              return RefreshIndicator(
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
                            const Text('Select your district: ',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 147, 147, 147),
                                    fontSize: 16)),
                            _buildDistrictDropdown(),
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
              );
            }
          }),
    );
  }

  Widget _buildDistrictDropdown() {
    return DropdownButton<String>(
      value: selectedDistrict,
      onChanged: (String? newValue) {
        setState(() {
          selectedDistrict = newValue!;
        });
        _refresh();
      },
      items: districts.map((String district) {
        return DropdownMenuItem<String>(
          value: district,
          child: Text(
            district,
            style: const TextStyle(
              color: Color.fromARGB(255, 147, 147, 147),
            ),
          ),
        );
      }).toList(),
    );
  }
}
