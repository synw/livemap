import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import '../models.dart';
import 'position_stream.dart';

class LiveMapState {
  LiveMapState(
      {@required this.mapController, @required this.changeFeedController})
      : assert(mapController != null),
        assert(changeFeedController != null) {
    _positionStreamState =
        PositionStreamState(changeFeedController: changeFeedController);
  }

  MapController mapController;
  StreamController changeFeedController;
  num zoom = 1.0;
  LatLng center = LatLng(0.0, 0.0);
  bool autoCenter;
  List<Marker> markers;
  Marker liveMarker;

  PositionStreamState _positionStreamState;

  get positionStream => _positionStreamState;

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

  toggleAutoCenter() {
    autoCenter = !autoCenter;
    print("TOGGLE AUTOCENTER TO $autoCenter");
    LiveMapControllerStateChange cmd =
        LiveMapControllerStateChange(name: "autoCenter", value: autoCenter);
    changeFeedController.sink.add(cmd);
  }

  updateMarkers(List<Marker> _m) {
    print("UPDATING MARKERS =$_m");
    markers = _m;
    LiveMapControllerStateChange cmd = LiveMapControllerStateChange(
      name: "updateMarkers",
      value: markers,
    );
    changeFeedController.sink.add(cmd);
  }

  addMarker(Marker marker) {
    markers.add(marker);
    updateMarkers(markers);
    LiveMapControllerStateChange cmd = LiveMapControllerStateChange(
      name: "addMarker",
      value: marker,
    );
    changeFeedController.sink.add(cmd);
  }
}
