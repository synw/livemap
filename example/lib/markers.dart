import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:livemap/livemap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geopoint/geopoint.dart';
import 'package:speech_bubble/speech_bubble.dart';

class _LivemapMarkersPageState extends State<LivemapMarkersPage> {
  static final MapController mapController = MapController();
  static final Stream<Position> positionStream =
      PositionStream(timeInterval: 3).stream;
  static final LiveMapController liveMapController = LiveMapController(
      mapController: mapController,
      positionStream: positionStream,
      positionStreamEnabled: false);

  final Map<String, LatLng> places = {
    "Notre-Dame": LatLng(48.853831, 2.348722),
    "Montmartre": LatLng(48.886463, 2.341169),
    "Champs-Elysées": LatLng(48.873932, 2.294821),
    "Chinatown": LatLng(48.827393, 2.361897),
    "Tour Eiffel": LatLng(48.85801, 2.294713)
  };

  @override
  void initState() {
    for (var place in places.keys) {
      liveMapController.addMarker(
          name: place, marker: buildMarker(place, places[place]));
    }
    super.initState();
  }

  Marker buildMarker(String name, LatLng point) {
    return Marker(
        anchorPos: AnchorPos.align(AnchorAlign.bottom),
        width: 180.0,
        height: 250.0,
        point: point,
        builder: (BuildContext context) {
          return GestureDetector(
            child: SpeechBubble(
              child: Text(
                name,
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
            ),
            onTap: () => print("MARKER $name : $point"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LiveMap(
      mapController: mapController,
      liveMapController: liveMapController,
      mapOptions: MapOptions(
        center: LatLng(48.853831, 2.348722),
        zoom: 12.0,
      ),
      titleLayer: TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c']),
    ));
  }
}

class LivemapMarkersPage extends StatefulWidget {
  @override
  _LivemapMarkersPageState createState() => _LivemapMarkersPageState();
}
