// Import necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tag_me/constants/constants.dart';
import 'package:tag_me/HomePage/EventBox/EventBox.dart';
import 'package:tag_me/utilities/event.dart';
import 'package:tag_me/utilities/eventFunctions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/HomePage';

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: khomePageBackgroundColor,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No ongoing events available.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            // Process the data
            List<Event> ongoingEvents =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

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
                coordinates:
                    Map<String, double>.from(data['coordinates'] ?? {}),
                participants: List<String>.from(
                  (data['participants'] as List<dynamic>?)?.cast<String>() ??
                      [],
                ),
                isParticipating: data['participants'].contains(
                        FirebaseAuth.instance.currentUser?.displayName) ??
                    false,
              );
            }).toList();

            return ListView.builder(
              itemCount: ongoingEvents.length,
              itemBuilder: (context, index) {
                if (!checkStartTime(ongoingEvents[index].startTime)) {
                  return EventBox(event: ongoingEvents[index]);
                }
                return null;
              },
            );
          },
        ),
      ),
    );
  }
}
