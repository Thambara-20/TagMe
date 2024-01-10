// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:tag_me/utilities/Location.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with OSMMixinObserver {
  late MapController mapController;
  GeoPoint? selectedPoint = GeoPoint(latitude: 6.9271, longitude: 79.8612);

  @override
  initState()  {
    super.initState();
    try {
      mapController = MapController(
        initPosition: GeoPoint(latitude: 6.9271, longitude: 79.8612),
        areaLimit: BoundingBox(
          east: 8.88,
          north: 7.0,
          south: 5.9,
          west: 79.52,
        ),
      );

      mapController.addObserver(this);
    } catch (e) {
      _close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: OSMFlutter(
              controller: mapController,
              osmOption: OSMOption(
                userTrackingOption: const UserTrackingOption(
                  enableTracking: true,
                  unFollowUser: false,
                ),
                zoomOption: const ZoomOption(
                  initZoom: 8,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                userLocationMarker: UserLocationMaker(
                  personMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.location_history_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.double_arrow,
                      size: 48,
                    ),
                  ),
                ),
                roadConfiguration: const RoadOption(
                  roadColor: Colors.yellowAccent,
                ),
                markerOption: MarkerOption(
                  defaultMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 56,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (selectedPoint != null)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedPoint);
              },
              child: const Text('Set Location'),
            ),
        ],
      ),
    );
  }

  Future<void> selectLocation(GeoPoint selectedPoint) async {
    mapController.addMarker(selectedPoint,
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.place,
            color: Color.fromARGB(255, 191, 64, 0),
            size: 48,
          ),
        ));

    setState(() {
      this.selectedPoint = selectedPoint;
    });
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {}
  }

  @override
  void onSingleTap(GeoPoint position) {
    super.onSingleTap(position);
    selectLocation(position);
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  void _close() {
    Navigator.pop(context);
  }
}
