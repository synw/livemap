# Example

   ```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';

class SimpleLiveMapPage extends StatefulWidget {
  @override
  _SimpleLiveMapPageState createState() => _SimpleLiveMapPageState();
}

class _SimpleLiveMapPageState extends State<SimpleLiveMapPage> {
  _SimpleLiveMapPageState() {
    mapController = MapController();
    liveMapController = LiveMapController(mapController: mapController);
  }

  MapController mapController;
  LiveMapController liveMapController;

  @override
  void dispose() {
    liveMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiveMap(
        mapController: mapController,
        liveMapController: liveMapController,
        mapOptions: MapOptions(
          center: LatLng(51.0, 0.0),
          zoom: 17.0,
        ),
        titleLayer: TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
      ),
    );
  }
}

   ```
