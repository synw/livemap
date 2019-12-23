import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:device/device.dart';
import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';

class _LivemapMarkerPageState extends State<LivemapMarkerPage> {
  _LivemapMarkerPageState();

  LiveMapController liveMapController;
  IconData markerIcon = Icons.location_on;

  Marker liveMarkerBuilder(Device device) {
    assert(device != null);
    assert(device.position != null);
    return Marker(
        point: device.position.point,
        builder: (BuildContext c) => Container(
            child: Icon(markerIcon, size: 45.0, color: Colors.orange)));
  }

  @override
  void initState() {
    liveMapController = LiveMapController(
        liveMarkerBuilder: liveMarkerBuilder,
        mapController: MapController(),
        autoCenter: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LiveMap(
            controller: liveMapController,
            center: LatLng(51.0, 0.0),
            zoom: 13.0),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit_location),
          onPressed: () => setState(() {
            if (markerIcon == Icons.location_on) {
              markerIcon = Icons.airport_shuttle;
            } else {
              markerIcon = Icons.location_on;
            }
          }),
        ));
  }

  @override
  void dispose() {
    liveMapController.dispose();
    super.dispose();
  }
}

class LivemapMarkerPage extends StatefulWidget {
  LivemapMarkerPage();

  @override
  _LivemapMarkerPageState createState() => _LivemapMarkerPageState();
}
