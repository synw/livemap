import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'markers.dart';

class LiveMapState {
  LiveMapState({@required this.mapController, @required this.notify})
      : assert(mapController != null);

  final MapController mapController;
  final Function notify;
  bool autoCenter = true;

  MarkersState _markersState;

  MarkersState get markersState => _markersState;

  Future<void> zoomIn() async {
    num z = mapController.zoom + 1;
    mapController.move(mapController.center, z);
    notify("zoom", z);
  }

  Future<void> zoomOut() async {
    num z = mapController.zoom - 1;
    mapController.move(mapController.center, z);
    notify("zoom", z);
  }

  Future<void> centerOnPosition(Position position) async {
    //print("CENTER ON $position");
    LatLng _center = LatLng(position.latitude, position.longitude);
    mapController.move(_center, mapController.zoom);
    notify("center", _center);
  }

  Future<void> centerOnPoint(LatLng point) async {
    mapController.move(point, mapController.zoom);
    notify("center", point);
  }

  Future<void> toggleAutoCenter() async {
    autoCenter = !autoCenter;
    if (autoCenter) _markersState.centerOnLiveMarker();
    //print("TOGGLE AUTOCENTER TO $autoCenter");
    notify("toggleAutoCenter", autoCenter);
  }
}
