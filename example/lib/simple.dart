import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geopoint/geopoint.dart';
import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';

class SimpleLiveMapPage extends StatefulWidget {
  @override
  _SimpleLiveMapPageState createState() => _SimpleLiveMapPageState();
}

class _SimpleLiveMapPageState extends State<SimpleLiveMapPage> {
  static final MapController mapController = MapController();
  static final LiveMapController liveMapController =
      LiveMapController(mapController: mapController);
  static final Stream<Position> positionStream =
      PositionStream(timeInterval: 3).stream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiveMap(
        positionStream: positionStream,
        mapController: mapController,
        liveMapController: liveMapController,
        liveMapOptions: LiveMapOptions(
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
