import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LiveMapControllerStateChange {
  LiveMapControllerStateChange({@required this.name, @required this.value})
      : assert(name != null),
        assert(value != null);

  String name;
  dynamic value;

  @override
  String toString() {
    return "${this.name} ${this.value}";
  }
}

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

class LiveMapState {
  LiveMapState(
      {@required this.mapController, @required this.stateChangeFeedController});
  /* : center = LatLng(0.0, 0.0),
        zoom = 1.0 {
    mapController.onReady.then((_) {
      print("MAP READY");
      //center = mapController.center;
      //zoom = mapController.zoom;
      //center();
    });
}*/

  MapController mapController;
  StreamController stateChangeFeedController;
  num zoom = 1.0;
  LatLng center = LatLng(0.0, 0.0);
  bool positionStreamEnabled;
  List<Marker> markers;
  Marker liveMarker;

  zoomIn() async {
    zoom++;
    mapController.move(mapController.center, zoom);
  }

  zoomOut() async {
    zoom--;
    mapController.move(mapController.center, zoom);
  }

  centerOnPosition(Position position) {
    print("CENTER ON $position");
    center = LatLng(position.latitude, position.longitude);
    print("Center: $center / Zoom : $zoom");
    mapController.move(center, zoom);
  }

  togglePositionStream() {
    positionStreamEnabled = !positionStreamEnabled;
    print("TOGGLE POSITION STREAM TO $positionStreamEnabled");
    LiveMapControllerStateChange cmd = LiveMapControllerStateChange(
        name: "positionStream", value: positionStreamEnabled);
    stateChangeFeedController.sink.add(cmd);
  }

  updateMarkers(List<Marker> _m) {
    print("UPDATING MARKERS =$_m");
    markers = _m;
    LiveMapControllerStateChange cmd = LiveMapControllerStateChange(
      name: "updateMarkers",
      value: markers,
    );
    stateChangeFeedController.sink.add(cmd);
  }

  addMarker(Marker marker) {
    markers.add(marker);
    updateMarkers(markers);
    LiveMapControllerStateChange cmd = LiveMapControllerStateChange(
      name: "addMarker",
      value: marker,
    );
    stateChangeFeedController.sink.add(cmd);
  }
}
