import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'models/controller_state_change.dart';
import 'state/markers.dart';
import 'state/map.dart';

class LiveMapController {
  LiveMapController(
      {@required this.mapController,
      @required this.positionStream,
      this.positionStreamEnabled})
      : assert(mapController != null) {
    positionStreamEnabled = positionStreamEnabled ?? false;
    _mapState = LiveMapState(
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

  LiveMapState _mapState;
  MarkersState _markersState;

  StreamSubscription<Position> _positionStreamSubscription;

  static final StreamController _changeFeedController =
      StreamController<LiveMapControllerStateChange>.broadcast();

  get changeFeed => _changeFeedController.stream;
  get zoom => _mapState.zoom;
  get center => _mapState.center;
  get autoCenterEnabled => _mapState.autoCenter;
  get markers => _mapState.markers;

  set zoom(double z) => _mapState.zoom = z;
  set center(LatLng p) => _mapState.center = p;

  dispose() {
    print("DISPOSE LIVEMAP CONTROLLER");
    _changeFeedController.close();
    _positionStreamSubscription.cancel();
  }

  zoomIn() => _mapState.zoomIn();
  zoomOut() => _mapState.zoomOut();
  centerOnPosition(pos) => _mapState.centerOnPosition(pos);
  recenter() => _mapState.recenter();
  toggleAutoCenter() => _mapState.toggleAutoCenter();
  updateMarkers(Position p) => _mapState.updateMarkers(p);
  addMarker(m) => _mapState.addMarker(m);

  onPositionChanged(MapPosition mapPosition, bool hasGesture) {
    zoom = mapPosition.zoom;
    center = mapPosition.center;
    print("Z ${_mapState.zoom}");
    print("C ${_mapState.center}");
    if (hasGesture == true) {
      print("GESTURE");
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
