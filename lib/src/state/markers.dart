import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MarkersState {
  MarkersState({@required this.mapController, @required this.notify})
      : assert(mapController != null);

  final MapController mapController;
  final Function notify;

  List<Map<String, dynamic>> _namedMarkers = [];
  var _markers = <Marker>[];
  Marker _liveMarker = Marker(
      point: LatLng(0.0, 0.0),
      width: 80.0,
      height: 80.0,
      builder: _liveMarkerWidgetBuilder);

  List<Marker> get markers => _markers;
  List<Map<String, dynamic>> get namedMarkers => _namedMarkers;

  void updateLiveGeoMarkerFromPosition({@required Position position}) {
    if (position == null) throw ArgumentError("position must not be null");
    print("UPDATING LIVE MARKER FROM POS $position");
    LatLng point = LatLng(position.latitude, position.longitude);
    removeMarker(name: "livemarker");
    Marker liveMarker = Marker(
        point: point,
        width: 80.0,
        height: 80.0,
        builder: _liveMarkerWidgetBuilder);
    _liveMarker = liveMarker;
    addMarker(marker: _liveMarker, name: "livemarker");
  }

  void addMarker({@required Marker marker, @required String name}) {
    if (marker == null) throw ArgumentError("marker must not be null");
    if (name == null) throw ArgumentError("name must not be null");
    //print("STATE ADD MARKER $name");
    //print("STATE MARKERS: $_namedMarkers");
    _namedMarkers.add({"name": name, "marker": marker});
    //print("STATE MARKERS AFTER ADD: $_namedMarkers");
    _buildMarkers();
    notify("updateMarkers", _markers);
  }

  void removeMarker({@required String name}) {
    if (name == null) throw ArgumentError("name must not be null");
    //if (name != "livemarker") {
    //print("STATE REMOVE MARKER $name");
    //print("STATE MARKERS: $_namedMarkers");
    //}
    _namedMarkers.removeWhere((item) => item["name"] == name);
    _buildMarkers();
    notify("updateMarkers", _markers);
  }

  void centerOnLiveMarker() {
    mapController.move(_liveMarker.point, mapController.zoom);
  }

  void _buildMarkers() {
    var listMarkers = <Marker>[];
    //print("BEFORE BUILD MARKERS");
    //_printMarkers();
    for (var m in _namedMarkers) {
      //print("Adding ${m["name"]}");
      listMarkers.add(m["marker"]);
    }
    _markers = listMarkers;
    //print("AFTER BUILD MARKERS");
    //_printMarkers();
  }

  _printMarkers() {
    for (var m in markers) {
      print("${m.point}");
    }
  }

  static Widget _liveMarkerWidgetBuilder(BuildContext _) {
    return Container(
      child: Icon(
        Icons.directions,
        color: Colors.red,
      ),
    );
  }
}
