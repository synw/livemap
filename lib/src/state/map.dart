import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import '../models.dart';
import 'position_stream.dart';

class LiveMapState {
  LiveMapState(
      {@required this.mapController, @required this.changeFeedController})
      : assert(mapController != null),
        assert(changeFeedController != null) {
    _positionStreamState =
        PositionStreamState(changeFeedController: changeFeedController);
  }

  MapController mapController;
  StreamController changeFeedController;
  num zoom = 1.0;
  LatLng center = LatLng(0.0, 0.0);
  LatLng viewPortCenter = LatLng(0.0, 0.0);
  bool autoCenter = true;
  LatLng liveMarkerPosition = LatLng(0.0, 0.0);
  List<Marker> _markers;

  PositionStreamState _positionStreamState;

  get positionStream => _positionStreamState;

  zoomIn() async {
    zoom++;
    mapController.move(mapController.center, zoom);
    notify("zoom", zoom);
  }

  zoomOut() async {
    zoom--;
    mapController.move(mapController.center, zoom);
    notify("zoom", zoom);
  }

  centerOnPosition(Position position) {
    print("CENTER ON $position");
    center = LatLng(position.latitude, position.longitude);
    print("Center: $center / Zoom : $zoom");
    print("MAp controller center: $center / Zoom : $zoom");
    mapController.move(center, mapController.zoom);
    notify("center", center);
  }

  recenter() {
    print("RECENTER");
    mapController.move(center, mapController.zoom);
    notify("center", center);
  }

  toggleAutoCenter() {
    autoCenter = !autoCenter;
    if (autoCenter) recenter();
    print("TOGGLE AUTOCENTER TO $autoCenter");
    notify("toggleAutoCenter", autoCenter);
  }

  updateMarkers(List<Marker> m) {
    print("UPDATING MARKERS =$m");
    _markers = m;
    notify("updateMarkers", m);
  }

  addMarker(Marker m) {
    _markers.add(m);
    updateMarkers(_markers);
    notify("addMarker", m);
  }

  notify(String name, dynamic value) {
    LiveMapControllerStateChange cmd = LiveMapControllerStateChange(
      name: name,
      value: value,
    );
    changeFeedController.sink.add(cmd);
  }
}
