import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geopoint/geopoint.dart';
import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';
import 'package:geopoint_location/geopoint_location.dart';

class LiveMapWithBottomBarMapPage extends StatefulWidget {
  @override
  _LiveMapWithBottomBarMapPageState createState() =>
      _LiveMapWithBottomBarMapPageState();
}

class _LiveMapWithBottomBarMapPageState
    extends State<LiveMapWithBottomBarMapPage> {
  _LiveMapWithBottomBarMapPageState() {
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
    return Scaffold(
      body: LiveMap(
        controller: liveMapController,
        center: LatLng(0.0, 0.0),
        zoom: 16.0,
      ),
      bottomNavigationBar: LiveMapBottomNavigationBar(
        liveMapController: liveMapController,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => addGeoMarkerFromCurrentPosition(),
      ),
    );
  }

  void addGeoMarkerFromCurrentPosition() async {
    GeoPoint gp = await geoPointFromLocation(name: "Current position");
    Marker m = Marker(
        width: 180.0,
        height: 250.0,
        point: gp.point,
        builder: (BuildContext context) {
          return Icon(Icons.location_on);
        });
    await liveMapController.addMarker(marker: m, name: "Current position");
    await liveMapController.fitMarker("Current position");
  }
}
