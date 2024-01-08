// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with OSMMixinObserver {
  late MapController mapController;
  GeoPoint? selectedPoint;

  @override
  void initState() {
    super.initState();
    mapController = MapController(
      initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
      areaLimit: BoundingBox(
        east: 10.4922941,
        north: 47.8084648,
        south: 45.817995,
        west: 5.9559113,
      ),
    );

    mapController.addObserver(this);
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
            color: Colors.green,
            size: 48,
          ),
        ));

    setState(() {
      this.selectedPoint = selectedPoint;
    });

  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
    }
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
}