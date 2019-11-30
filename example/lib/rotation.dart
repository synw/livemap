import 'dart:async';
import 'package:geopoint/geopoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';

class _RotationPageState extends State<RotationPage> {
  _RotationPageState() {
    mapController = MapController();
    liveMapController = LiveMapController(
        mapController: mapController, autoCenter: true, autoRotate: true);
  }

  MapController mapController;
  LiveMapController liveMapController;
  StreamSubscription<GeoPoint> posSub;
  var status = "";

  @override
  void initState() {
    posSub = liveMapController.positionStream.listen((pos) {
      print("Bearing: ${pos.heading}");
      setState(() {
        status = "${pos.heading}";
      });
    });
    super.initState();
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
        ),
        Positioned(
          child: Text(status, textScaleFactor: 1.3),
          bottom: 15.0,
          right: 15.0,
        )
      ],
    ));
  }

  @override
  void dispose() {
    liveMapController.dispose();
    posSub.cancel();
    super.dispose();
  }
}

class RotationPage extends StatefulWidget {
  @override
  _RotationPageState createState() => _RotationPageState();
}
