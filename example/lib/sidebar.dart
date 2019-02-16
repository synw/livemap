import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geopoint/geopoint.dart';
import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';

class _SideBarPageState extends State<SideBarPage> {
  static final MapController mapController = MapController();
  static final Stream<Position> positionStream =
      PositionStream(timeInterval: 3).stream;
  static final LiveMapController liveMapController = LiveMapController(
      mapController: mapController, positionStream: positionStream);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        LiveMap(
          mapController: mapController,
          liveMapController: liveMapController,
          mapOptions: MapOptions(
            center: LatLng(51.0, 0.0),
            zoom: 17.0,
            //onPositionChanged: liveMapController.onPositionChanged,
          ),
          titleLayer: TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
        ),
        LiveMapSideBar(
          top: 35.0,
          right: 15.0,
          liveMapController: liveMapController,
        )
      ],
    ));
  }
}

class SideBarPage extends StatefulWidget {
  @override
  _SideBarPageState createState() => _SideBarPageState();
}
