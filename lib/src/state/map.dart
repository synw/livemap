import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import '../models/controller_state_change.dart';

class LiveMapState {
  LiveMapState(
      {@required this.mapController, @required this.changeFeedController})
      : assert(mapController != null),
        assert(changeFeedController != null);

  final MapController mapController;
  final StreamController changeFeedController;
  //num zoom = 1.0;
  bool autoCenter = true;
  LatLng liveMarkerPosition = LatLng(0.0, 0.0);
  List<Marker> markers = <Marker>[];

  LatLng initialCenter = LatLng(0.0, 0.0);
  double initialZoom = 1.0;

  void zoomIn() async {
    num z = mapController.zoom + 1;
    mapController.move(mapController.center, z);
    notify("zoom", z);
  }

  void zoomOut() async {
    num z = mapController.zoom - 1;
    mapController.move(mapController.center, z);
    notify("zoom", z);
  }

  void centerOnPosition(Position position) {
    print("CENTER ON $position");
    LatLng _center = LatLng(position.latitude, position.longitude);
    mapController.move(_center, mapController.zoom);
    notify("center", _center);
  }

  void toggleAutoCenter() {
    autoCenter = !autoCenter;
    if (autoCenter) centerOnLiveMarker();
    print("TOGGLE AUTOCENTER TO $autoCenter");
    notify("toggleAutoCenter", autoCenter);
  }

  void centerOnLiveMarker() {
    mapController.move(liveMarkerPosition, mapController.zoom);
  }

  void updateMarkers(Position pos) {
    print("UPDATING MARKERS =$pos");
    markers = [buildLivemarker(liveMarkerPosition)];
    notify("updateMarkers", markers);
  }

  void addMarker(Marker m) {
    markers.add(m);
    //updateMarkers(markers);
    notify("addMarker", m);
  }

  void notify(String name, dynamic value) {
    LiveMapControllerStateChange cmd = LiveMapControllerStateChange(
      name: name,
      value: value,
    );
    changeFeedController.sink.add(cmd);
  }

  Marker buildLivemarker(LatLng position) {
    num lat =
        mapController.ready ? mapController.center.latitude : initialCenter;
    num lon =
        mapController.ready ? mapController.center.longitude : initialCenter;
    LatLng _position = position ?? LatLng(lat, lon);
    return Marker(
      width: 80.0,
      height: 80.0,
      point: _position,
      builder: (ctx) => Container(
            child: Icon(
              Icons.directions,
              color: Colors.red,
            ),
          ),
    );
  }
}
