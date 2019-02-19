import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import '../models/controller_state_change.dart';
import 'markers.dart';

class LiveMapState {
  LiveMapState(
      {@required this.mapController, @required this.changeFeedController})
      : assert(mapController != null),
        assert(changeFeedController != null) {
    _markersState = MarkersState(
      mapController: mapController,
      notify: notify,
    );
  }

  final MapController mapController;
  final StreamController changeFeedController;
  bool autoCenter = true;

  MarkersState _markersState;

  MarkersState get markersState => _markersState;

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
    if (autoCenter) _markersState.centerOnLiveMarker();
    print("TOGGLE AUTOCENTER TO $autoCenter");
    notify("toggleAutoCenter", autoCenter);
  }

  void notify(String name, dynamic value) {
    LiveMapControllerStateChange cmd = LiveMapControllerStateChange(
      name: name,
      value: value,
    );
    changeFeedController.sink.add(cmd);
  }
}
