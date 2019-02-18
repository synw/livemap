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
    positionStreamEnabled = positionStreamEnabled ?? true;
    _changeFeedController =
        StreamController<LiveMapControllerStateChange>.broadcast();
    _mapState = LiveMapState(
        mapController: mapController,
        changeFeedController: _changeFeedController);
    mapController.onReady.then((_) {
      _positionStreamSubscription = positionStream.listen((Position position) {
        _positionStreamCallbackAction(position);
      });
      if (!positionStreamEnabled) _positionStreamSubscription.pause();
    });
  }

  final MapController mapController;
  MapOptions mapOptions;
  final Stream<Position> positionStream;
  bool positionStreamEnabled;

  LiveMapState _mapState;
  MarkersState _markersState;

  StreamSubscription<Position> _positionStreamSubscription;

  static StreamController _changeFeedController;

  get changeFeed => _changeFeedController.stream;
  get zoom => mapController.zoom;
  get center => mapController.center;
  get autoCenterEnabled => _mapState.autoCenter;
  get markers => _mapState.markers;

  setMapOptions(MapOptions mapOptions) {
    _mapState.initialZoom = mapOptions.zoom;
    _mapState.initialCenter = _mapState.initialCenter = mapOptions.center;
  }

  dispose() {
    //print("DISPOSE LIVEMAP CONTROLLER");
    _changeFeedController.close();
    _positionStreamSubscription.cancel();
  }

  zoomIn() => _mapState.zoomIn();
  zoomOut() => _mapState.zoomOut();
  centerOnPosition(pos) => _mapState.centerOnPosition(pos);
  toggleAutoCenter() => _mapState.toggleAutoCenter();
  updateMarkers(Position p) => _mapState.updateMarkers(p);
  addMarker(m) => _mapState.addMarker(m);
  centerOnLiveMarker() => _mapState.centerOnLiveMarker();

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

  void _positionStreamCallbackAction(Position position) {
    print("POSITION UPDATE $position");
    _mapState.liveMarkerPosition =
        LatLng(position.latitude, position.longitude);
    updateMarkers(position);
    if (autoCenterEnabled) centerOnPosition(position);
  }
}
