import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import '../models.dart';

class LiveMapState {
  LiveMapState(
      {@required this.mapController, @required this.changeFeedController})
      : assert(mapController != null),
        assert(changeFeedController != null);

  final MapController mapController;
  final StreamController changeFeedController;
  num zoom = 1.0;
  LatLng center = LatLng(0.0, 0.0);
  LatLng viewPortCenter = LatLng(0.0, 0.0);
  bool autoCenter = true;
  LatLng liveMarkerPosition = LatLng(0.0, 0.0);
  List<Marker> markers = <Marker>[];

  void zoomIn() async {
    zoom++;
    mapController.move(mapController.center, zoom);
    notify("zoom", zoom);
  }

  void zoomOut() async {
    zoom--;
    mapController.move(mapController.center, zoom);
    notify("zoom", zoom);
  }

  void centerOnPosition(Position position) {
    print("CENTER ON $position");
    center = LatLng(position.latitude, position.longitude);
    print("Center: $center / Zoom : $zoom");
    print("MAp controller center: $center / Zoom : $zoom");
    mapController.move(center, mapController.zoom);
    notify("center", center);
  }

  void recenter() {
    print("RECENTER");
    mapController.move(center, mapController.zoom);
    notify("center", center);
  }

  void toggleAutoCenter() {
    autoCenter = !autoCenter;
    if (autoCenter) recenter();
    print("TOGGLE AUTOCENTER TO $autoCenter");
    notify("toggleAutoCenter", autoCenter);
  }

  //void updateLiveMarker() {}

  void updateMarkers(Position pos) {
    print("UPDATING MARKERS =$pos");
    LatLng point = LatLng(pos.latitude, pos.longitude);
    markers = [buildLivemarker(point)];
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
    num lat = mapController.ready ? mapController.center.latitude : center;
    num lon = mapController.ready ? mapController.center.longitude : center;
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
