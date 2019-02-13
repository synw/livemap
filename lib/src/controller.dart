import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'models.dart';
import 'state.dart';

class LiveMapController {
  LiveMapController({@required this.mapController})
      : _state = LiveMapState(
            mapController: mapController,
            changeFeedController: _changeFeedController),
        assert(mapController != null);

  LiveMapState _state;
  MapController mapController;

  static final StreamController _changeFeedController =
      StreamController<LiveMapControllerStateChange>.broadcast();

  get stateChangeFeed => _changeFeedController.stream;
  get positionStreamEnabled => _state.positionStreamEnabled;
  get zoom => _state.zoom;
  get center => _state.center;
  get state => state;

  set positionStreamEnabled(bool _p) => _state.positionStreamEnabled = _p;
  set zoom(double z) => _state.zoom = z;
  set center(LatLng p) => _state.center = p;

  dispose() {
    _changeFeedController.close();
  }

  zoomIn() => _state.zoomIn();
  zoomOut() => _state.zoomOut();
  centerOnPosition(pos) => _state.centerOnPosition(pos);
  togglePositionStream() => _state.togglePositionStream();
  updateMarkers(m) => _state.updateMarkers(m);
  addMarker(m) => _state.addMarker(m);
}
