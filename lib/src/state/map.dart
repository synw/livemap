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
  double _zoom = 1.0;
  LatLng _center = LatLng(0.0, 0.0);

  MarkersState get markersState => _markersState;

  Future<void> zoomIn() async {
    //print("ZOOM IN");
    num z = mapController.zoom + 1;
    mapController.move(mapController.center, z);
    _zoom = z;
    notify("zoom", z, zoomIn);
  }

  Future<void> zoomOut() async {
    //print("ZOOM OUT");
    num z = mapController.zoom - 1;
    mapController.move(mapController.center, z);
    _zoom = z;
    notify("zoom", z, zoomOut);
  }

  Future<void> zoomTo(double value) async {
    //print("ZOOM TO $value");
    mapController.move(mapController.center, value);
    _zoom = value;
    notify("zoom", value, zoomOut);
  }

  Future<void> centerOnPosition(Position position) async {
    //print("CENTER ON $position");
    LatLng _newCenter = LatLng(position.latitude, position.longitude);
    mapController.move(_newCenter, mapController.zoom);
    _center = _newCenter;
    notify("center", _newCenter, centerOnPosition);
  }

  Future<void> centerOnPoint(LatLng point) async {
    mapController.move(point, mapController.zoom);
    _center = point;
    notify("center", point, centerOnPoint);
  }

  Future<void> toggleAutoCenter() async {
    autoCenter = !autoCenter;
    if (autoCenter) _markersState.centerOnLiveMarker();
    //print("TOGGLE AUTOCENTER TO $autoCenter");
    notify("toggleAutoCenter", autoCenter, toggleAutoCenter);
  }

  /// Tell listeners that the zoom or center has changed
  ///
  /// This is used to handle the gestures
  void onPositionChanged(MapPosition posChange, bool gesture) {
    //print("Position changed: zoom ${posChange.zoom} / ${posChange.center}");
    if (posChange.zoom != _zoom) {
      _zoom = posChange.zoom;
      notify("zoom", posChange.zoom, onPositionChanged);
    }
    if (posChange.center != _center) {
      _center = posChange.center;
      notify("center", posChange.center, onPositionChanged);
    }
  }
}
