import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class LiveMapControllerCommand {
  LiveMapControllerCommand({@required this.name, @required this.value})
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
            commandsController: _commandsController);

  LiveMapState _state;
  MapController mapController;

  static final StreamController _commandsController =
      StreamController<LiveMapControllerCommand>();

  get commands => _commandsController.stream;
  get positionStreamEnabled => _state.positionStreamEnabled ?? false;

  dispose() {
    _commandsController.close();
  }

  zoomIn() => _state.zoomIn();
  zoomOut() => _state.zoomOut();
  centerOnPosition(pos) => _state.centerOnPosition(pos);
  togglePositionStream() => _state.togglePositionStream();
  updateMarkers(m) => _state.updateMarkers(m);

  set setPositionStreamEnabled(bool _p) => _state.positionStreamEnabled = _p;
  set setZoom(num z) => _state.zoom = z;
  set setCenter(LatLng c) => _state.center = c;
}

class LiveMapState {
  LiveMapState(
      {@required this.mapController, @required this.commandsController});
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
  StreamController commandsController;
  num zoom = 1.0;
  LatLng center = LatLng(0.0, 0.0);
  bool positionStreamEnabled;
  List<Marker> markers;
  Marker liveMarker;

  zoomIn() async {
    zoom++;
    mapController.move(center, zoom);
  }

  zoomOut() async {
    zoom--;
    mapController.move(center, zoom);
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
    LiveMapControllerCommand cmd = LiveMapControllerCommand(
        name: "setPositionStream", value: positionStreamEnabled);
    commandsController.sink.add(cmd);
  }

  updateMarkers(List<Marker> _m) {
    print("UPDATING MARKERS =$_m");
    markers = _m;
    LiveMapControllerCommand cmd = LiveMapControllerCommand(
      name: "updateMarkers",
      value: markers,
    );
    commandsController.sink.add(cmd);
  }

  addMarker(Marker marker) {}
}
