import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'models/controller_state_change.dart';
import 'state/map.dart';
import 'state/markers.dart';
import 'state/lines.dart';
import 'position_stream.dart';

/// The map controller
class LiveMapController {
  /// Provide a Flutter map [MapController]
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
    _markersState = MarkersState(
      mapController: mapController,
      notify: notify,
    );
    _linesState = LinesState(
      notify: notify,
    );
    _mapState = LiveMapState(
      mapController: mapController,
      notify: notify,
      markersState: _markersState,
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

  /// The Flutter Map [MapController]
  final MapController mapController;

  /// The Flutter Map [MapOptions]
  MapOptions mapOptions;

  /// The Geolocator position stream
  Stream<Position> positionStream;

  /// Enable or not the position stream
  bool positionStreamEnabled;

  LiveMapState _mapState;
  MarkersState _markersState;
  LinesState _linesState;
  StreamSubscription<Position> _positionStreamSubscription;
  final Completer<Null> _readyCompleter = Completer<Null>();
  final _subject = PublishSubject<LiveMapControllerStateChange>();

  /// On ready callback: this is fired when the contoller is ready
  Future<Null> get onReady => _readyCompleter.future;

  /// A stream with changes occuring on the map
  Observable<LiveMapControllerStateChange> get changeFeed =>
      _subject.distinct();

  /// The map zoom value
  double get zoom => mapController.zoom;

  /// The map center value
  LatLng get center => mapController.center;

  /// Is autocenter enabled
  bool get autoCenter => _mapState.autoCenter;

  /// The markers present on the map
  List<Marker> get markers => _markersState.markers;

  /// The markers present on the map and their names
  Map<String, Marker> get namedMarkers => _markersState.namedMarkers;

  /// The lines present on the map
  List<Polyline> get lines => _linesState.lines;

  /// Dispose the position stream subscription
  void dispose() {
    if (_positionStreamSubscription != null)
      _positionStreamSubscription.cancel();
  }

  /// Zoom in one level
  Future<void> zoomIn() => _mapState.zoomIn();

  /// Zoom out one level
  Future<void> zoomOut() => _mapState.zoomOut();

  /// Zoom to level
  Future<void> zoomTo(double value) => _mapState.zoomTo(value);

  /// Center the map on a [Position]
  Future<void> centerOnPosition(Position pos) =>
      _mapState.centerOnPosition(pos);

  /// Toggle autocenter state
  Future<void> toggleAutoCenter() => _mapState.toggleAutoCenter();

  /// Center the map on the livemarker
  Future<void> centerOnLiveMarker() => _markersState.centerOnLiveMarker();

  /// Center the map on a [LatLng]
  Future<void> centerOnPoint(LatLng point) => _mapState.centerOnPoint(point);

  /// The callback used to handle gestures and keep the state in sync
  void onPositionChanged(MapPosition pos, bool gesture) =>
      _mapState.onPositionChanged(pos, gesture);

  /// Add a marker on the map
  Future<void> addMarker({@required Marker marker, @required String name}) =>
      _markersState.addMarker(marker: marker, name: name);

  /// Remove a marker from the map
  Future<void> removeMarker({@required String name}) =>
      _markersState.removeMarker(name: name);

  /// Add multiple markers to the map
  Future<void> addMarkers({@required Map<String, Marker> markers}) =>
      _markersState.addMarkers(markers: markers);

  /// Remove multiple makers from the map
  Future<void> removeMarkers({@required List<String> names}) =>
      _markersState.removeMarkers(names: names);

  /// Add a line on the map
  Future<void> addLine(
          {@required String name,
          @required List<LatLng> points,
          double width = 1.0,
          Color color = Colors.green,
          bool isDotted = false}) =>
      _linesState.addLine(
          name: name,
          points: points,
          color: color,
          width: width,
          isDotted: isDotted);

  /// Toggle live position stream updates
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

  /// Notify to the changefeed
  void notify(String name, dynamic value, Function from) {
    LiveMapControllerStateChange change =
        LiveMapControllerStateChange(name: name, value: value, from: from);
    //if (change.name != "updateMarkers") print("STATE MUTATION: $change");
    _subject.add(change);
  }

  void _subscribeToPositionStream() {
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
