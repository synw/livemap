# Example

   ```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';

class LiveMapPage extends StatelessWidget {
  LiveMapPage() () {
    mapController = MapController();
    liveMapController = LiveMapController(mapController: mapController);
  }

  MapController mapController;
  LiveMapController liveMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LiveMap(
          mapController: mapController,
          liveMapController: liveMapController,
          mapOptions: MapOptions(
            center: LatLng(51.0, 0.0),
            zoom: 13.0,
          ),
          titleLayer: TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
        ),
  }

  @override
  void dispose() {
    liveMapController.dispose();
    super.dispose();
  }
}
   ```
