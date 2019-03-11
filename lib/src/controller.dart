import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'models/controller_state_change.dart';
import 'state/map.dart';
import 'state/markers.dart';
import 'position_stream.dart';

class LiveMapController {
  LiveMapController(
      {@required this.mapController,
      this.positionStream,
      this.positionStreamEnabled})
      : assert(mapController != null) {
    positionStreamEnabled = positionStreamEnabled ?? true;
    // get a new position stream
    if (positionStreamEnabled)
      positionStream = positionStream ?? initPositionStream();
    // init state
    _mapState = LiveMapState(
      mapController: mapController,
      notify: notify,
    );
    _markersState = MarkersState(
      mapController: mapController,
      notify: notify,
    );
    // subscribe to position stream
    mapController.onReady.then((_) {
      // listen to position stream
      if (positionStreamEnabled) _subscribeToPositionStream();
      // fire the map is ready callback
      if (!_readyCompleter.isCompleted) {
        _readyCompleter.complete();
      }
    });
  }

  final MapController mapController;
  MapOptions mapOptions;
  Stream<Position> positionStream;
  bool positionStreamEnabled;

  LiveMapState _mapState;
  MarkersState _markersState;
  StreamSubscription<Position> _positionStreamSubscription;
  Completer<Null> _readyCompleter = Completer<Null>();
  var _subject = PublishSubject<LiveMapControllerStateChange>();

  Future<Null> get onReady => _readyCompleter.future;

  Observable<LiveMapControllerStateChange> get changeFeed =>
      _subject.distinct();

  get zoom => mapController.zoom;
  get center => mapController.center;
  get autoCenter => _mapState.autoCenter;

  get markers => _markersState.markers;
  get namedMarkers => _markersState.namedMarkers;

  dispose() {
    _positionStreamSubscription.cancel();
  }

  Future<void> zoomIn() => _mapState.zoomIn();
  Future<void> zoomOut() => _mapState.zoomOut();
  Future<void> zoomTo(double value) => _mapState.zoomTo(value);
  Future<void> centerOnPosition(pos) => _mapState.centerOnPosition(pos);
  Future<void> toggleAutoCenter() => _mapState.toggleAutoCenter();
  Future<void> centerOnLiveMarker() => _markersState.centerOnLiveMarker();
  Future<void> centerOnPoint(LatLng point) => _mapState.centerOnPoint(point);

  void onPositionChanged(MapPosition pos, bool gesture) =>
      _mapState.onPositionChanged(pos, gesture);

  Future<void> addMarker({@required Marker marker, @required String name}) =>
      _markersState.addMarker(marker: marker, name: name);
  Future<void> removeMarker({@required String name}) =>
      _markersState.removeMarker(name: name);
  Future<void> addMarkers({@required Map<String, Marker> markers}) =>
      _markersState.addMarkers(markers: markers);
  Future<void> removeMarkers({@required List<String> names}) =>
      _markersState.removeMarkers(names: names);

  void togglePositionStreamSubscription({Stream<Position> newPositionStream}) {
    positionStreamEnabled = !positionStreamEnabled;
    //print("TOGGLE POSITION STREAM TO $positionStreamEnabled");
    if (!positionStreamEnabled) {
      //print("=====> LIVE MAP DISABLED");
      _positionStreamSubscription.cancel();
    } else {
      //print("=====> LIVE MAP ENABLED");
      newPositionStream = newPositionStream ?? initPositionStream();
      positionStream = newPositionStream;
      _subscribeToPositionStream();
    }
    notify("positionStream", positionStreamEnabled,
        togglePositionStreamSubscription);
  }

  void notify(String name, dynamic value, Function from) {
    LiveMapControllerStateChange change =
        LiveMapControllerStateChange(name: name, value: value, from: from);
    //if (change.name != "updateMarkers") print("STATE MUTATION: $change");
    _subject.add(change);
  }

  _subscribeToPositionStream() {
    //print('SUBSCRIBE TO NEW POSITION STREAM');
    _positionStreamSubscription = positionStream.listen((Position position) {
      _positionStreamCallbackAction(position);
    });
  }

  void _positionStreamCallbackAction(Position position) {
    //print("POSITION UPDATE $position");
    _markersState.updateLiveGeoMarkerFromPosition(position: position);
    if (autoCenter) centerOnPosition(position);
  }
}
