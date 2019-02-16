import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'models.dart';
import 'state/map.dart';

class LiveMapController {
  LiveMapController(
      {@required this.mapController,
      @required this.positionStream,
      this.positionStreamEnabled})
      : assert(mapController != null,
            (positionStreamEnabled == null) ? true : positionStreamEnabled) {
    _state = LiveMapState(
        mapController: mapController,
        changeFeedController: _changeFeedController);
    mapController.onReady.then((_) {
      _positionStreamSubscription = positionStream.listen((Position position) {
        print("POSITION UPDATE $position");
        updateMarkers(position);
        if (autoCenterEnabled) centerOnPosition(position);
      });
      if (!positionStreamEnabled) _positionStreamSubscription.pause();
    });
  }

  MapController mapController;
  final Stream<Position> positionStream;
  bool positionStreamEnabled;

  LiveMapState _state;
  StreamSubscription<Position> _positionStreamSubscription;

  static final StreamController _changeFeedController =
      StreamController<LiveMapControllerStateChange>.broadcast();

  get changeFeed => _changeFeedController.stream;
  get zoom => _state.zoom;
  get center => _state.center;
  get autoCenterEnabled => _state.autoCenter;
  get markers => _state.markers;

  set zoom(double z) => _state.zoom = z;
  set center(LatLng p) => _state.center = p;

  dispose() {
    print("DISPOSE LIVEMAP CONTROLLER");
    _changeFeedController.close();
    _positionStreamSubscription.cancel();
  }

  zoomIn() => _state.zoomIn();
  zoomOut() => _state.zoomOut();
  centerOnPosition(pos) => _state.centerOnPosition(pos);
  recenter() => _state.recenter();
  toggleAutoCenter() => _state.toggleAutoCenter();
  updateMarkers(Position p) => _state.updateMarkers(p);
  addMarker(m) => _state.addMarker(m);

  onPositionChanged(MapPosition mapPosition, bool hasGesture) {
    if (hasGesture == true) {
      //print("GESTURE $mapPosition");
      //viewPortCenter = mapPosition.center;
    } else {
      print("ON POSITION CHANGED");
    }
  }

  void togglePositionStreamSubscription() {
    positionStreamEnabled = !positionStreamEnabled;
    print("TOGGLE POSITION STREAM TO $positionStreamEnabled");
    if (!positionStreamEnabled) {
      print("=====> LIVE MAP DISABLED");
      _positionStreamSubscription.pause();
      //getPos();
    } else {
      print("=====> LIVE MAP ENABLED");
      if (_positionStreamSubscription.isPaused) {
        _positionStreamSubscription.resume();
      }
    }
    LiveMapControllerStateChange cmd = LiveMapControllerStateChange(
        name: "positionStream", value: positionStreamEnabled);
    _changeFeedController.sink.add(cmd);
  }
}
