import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'models.dart';
import 'state/map.dart';

class LiveMapController {
  LiveMapController({@required this.mapController})
      : assert(mapController != null),
        _state = LiveMapState(
            mapController: mapController,
            changeFeedController: _changeFeedController);

  LiveMapState _state;
  MapController mapController;

  static final StreamController _changeFeedController =
      StreamController<LiveMapControllerStateChange>.broadcast();

  get changeFeed => _changeFeedController.stream;
  get positionStream => _state.positionStream;
  get zoom => _state.zoom;
  get center => _state.center;
  get autoCenter => _state.autoCenter;
  get viewPortCenter => _state.viewPortCenter;

  set zoom(double z) => _state.zoom = z;
  set center(LatLng p) => _state.center = p;
  set viewPortCenter(LatLng p) => _state.viewPortCenter = p;

  dispose() {
    _changeFeedController.close();
  }

  zoomIn() => _state.zoomIn();
  zoomOut() => _state.zoomOut();
  centerOnPosition(pos) => _state.centerOnPosition(pos);
  recenter() => _state.recenter();
  togglePositionStream() => _state.positionStream.toggle();
  toggleAutoCenter() => _state.toggleAutoCenter();
  updateMarkers(m) => _state.updateMarkers(m);
  addMarker(m) => _state.addMarker(m);

  onPositionChanged(MapPosition mapPosition, bool hasGesture) {
    if (hasGesture == true) {
      //print("GESTURE $mapPosition");
      viewPortCenter = mapPosition.center;
    } else {
      print("ON POSITION CHANGED");
    }
  }
}
