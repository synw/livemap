import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';

class _SideBarPageState extends State<SideBarPage> {
  _SideBarPageState() {
    mapController = MapController();
    liveMapController = LiveMapController(
        autoCenter: true, mapController: mapController, verbose: true);
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
        body: Stack(
      children: <Widget>[
        LiveMap(
          controller: liveMapController,
          center: LatLng(51.0, 0.0),
          zoom: 17.0,
          //onPositionChanged: liveMapController.onPositionChanged,
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
