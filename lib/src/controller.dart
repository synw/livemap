import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'models.dart';
import 'state/map.dart';

class LiveMapController {
  LiveMapController({@required this.mapController})
      : _state = LiveMapState(
            mapController: mapController,
            stateChangeFeedController: _stateChangeFeedController);

  LiveMapState _state;
  MapController mapController;

  static final StreamController _stateChangeFeedController =
      StreamController<LiveMapControllerStateChange>.broadcast();

  get stateChangeFeed => _stateChangeFeedController.stream;
  get positionStreamEnabled => _state.positionStreamEnabled ?? true;

  dispose() {
    _stateChangeFeedController.close();
  }

  zoomIn() => _state.zoomIn();
  zoomOut() => _state.zoomOut();
  centerOnPosition(pos) => _state.centerOnPosition(pos);
  togglePositionStream() => _state.togglePositionStream();
  updateMarkers(m) => _state.updateMarkers(m);
  addMarker(m) => _state.addMarker(m);

  set positionStreamEnabled(bool _p) => _state.positionStreamEnabled = _p;
  set setZoom(num z) => _state.zoom = z;
  set setCenter(LatLng c) => _state.center = c;
}
