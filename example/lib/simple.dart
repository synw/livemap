import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:livemap/livemap.dart';

class SimpleLiveMapPage extends StatefulWidget {
  @override
  _SimpleLiveMapPageState createState() => _SimpleLiveMapPageState();
}

class _SimpleLiveMapPageState extends State<SimpleLiveMapPage> {
  _SimpleLiveMapPageState() {
    mapController = MapController();
    liveMapController =
        LiveMapController(autoCenter: true, mapController: mapController);
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
    return Scaffold(body: LiveMap(controller: liveMapController));
  }
}
