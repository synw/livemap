import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geopoint/geopoint.dart';
import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';

class LiveMapWithBottomBarMapPage extends StatefulWidget {
  @override
  _LiveMapWithBottomBarMapPageState createState() =>
      _LiveMapWithBottomBarMapPageState();
}

class _LiveMapWithBottomBarMapPageState
    extends State<LiveMapWithBottomBarMapPage> {
  static final MapController mapController = MapController();
  static final Stream<Position> positionStream =
      PositionStream(timeInterval: 3).stream;
  static final LiveMapController liveMapController = LiveMapController(
      mapController: mapController, positionStream: positionStream);

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
          center: LatLng(0.0, 0.0),
          zoom: 16.0,
        ),
        titleLayer: TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
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
    GeoPoint gp = await getGeoPoint(name: "Current position");
    GeoMarker gm = GeoMarker.fromGeoPoint(
        width: 180.0,
        height: 250.0,
        geoPoint: gp,
        builder: (BuildContext context) {
          return Icon(Icons.location_on);
        });
    liveMapController.addGeoMarker(gm);
  }
}
