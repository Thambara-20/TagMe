// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tag_me/utilities/locationService.dart';
import 'package:tag_me/models/event.dart';

class LocationPage extends StatefulWidget {
  final Event event;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const LocationPage(
      {Key? key,
      required this.event,
      required this.onBack,
      required this.onNext})
      : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    isOnline = widget.event.isOnline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(children: [
                  const Text(
                    'Select Event Type:',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 15),
                  OverflowBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isOnline ? Colors.black : Colors.grey,
                            foregroundColor: Colors.white, // Change text color
                            padding: const EdgeInsets.all(10), // Add padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  25), // Add border radius
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isOnline = true;
                              widget.event.isOnline = isOnline;
                              widget.event.location = 'Online Event';
                            });
                          },
                          child: const Text('Online',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                !isOnline ? Colors.black : Colors.grey,
                            foregroundColor: Colors.white, // Change text color
                            padding: const EdgeInsets.all(10), // Add padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  25), // Add border radius
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isOnline = false;
                              widget.event.isOnline = isOnline;
                              widget.event.location = 'Online Event';
                            });
                          },
                          child: const Text('Physical',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  if (!widget.event.isOnline) ...[
                    const Text(
                      'Select Location:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        var p = await showSimplePickerLocation(
                          // ignore: use_build_context_synchronously
                          context: context,
                          isDismissible: true,
                          title: "Select the location",
                          textConfirmPicker: "pick",
                          zoomOption: const ZoomOption(
                            initZoom: 8,
                          ),
                          initPosition: await getGeoPointFromLocation(
                              widget.event.coordinates),
                          radius: 10,
                        );

                        List<Placemark> placemarks = [];
                        if (p != null) {
                          placemarks = await placemarkFromCoordinates(
                              p.latitude, p.longitude);
                          widget.event.coordinates["latitude"] = p.latitude;
                          widget.event.coordinates["longtitude"] = p.longitude;
                        } else {
                          Position position =
                              await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high);
                          placemarks = await placemarkFromCoordinates(
                              position.latitude, position.longitude);
                        }
                        Placemark placemark = placemarks[0];
                        String town = placemark.locality ?? 'Unknown Town';

                        setState(() {
                          widget.event.location = town;
                        });
                      },
                      child: const Text('Select Location'),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          widget.event.location == "Online Event"
                              ? ""
                              : widget.event.location,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onBack();
                    },
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onNext();
                    },
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
