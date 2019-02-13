import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'models.dart';

class LiveMapState {
  LiveMapState(
      {@required this.mapController, @required this.changeFeedController});

  MapController mapController;
  StreamController changeFeedController;
  num zoom = 1.0;
  LatLng center = LatLng(0.0, 0.0);
  bool positionStreamEnabled;
  bool autoCenter;
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
    changeFeedController.sink.add(cmd);
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
