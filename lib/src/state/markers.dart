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

  Map<String, Marker> _namedMarkers = {};
  var _markers = <Marker>[];
  Marker _liveMarker = Marker(
      point: LatLng(0.0, 0.0),
      width: 80.0,
      height: 80.0,
      builder: _liveMarkerWidgetBuilder);

  List<Marker> get markers => _markers;
  Map<String, Marker> get namedMarkers => _namedMarkers;

  void updateLiveGeoMarkerFromPosition({@required Position position}) {
    if (position == null) throw ArgumentError("position must not be null");
    //print("UPDATING LIVE MARKER FROM POS $position");
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

  Future<void> addMarker(
      {@required Marker marker, @required String name}) async {
    if (marker == null) throw ArgumentError("marker must not be null");
    if (name == null) throw ArgumentError("name must not be null");
    //print("STATE ADD MARKER $name");
    //print("STATE MARKERS: $_namedMarkers");
    try {
      _namedMarkers[name] = marker;
    } catch (e) {
      throw ("Can not add marker: ${e.message}");
    }
    //print("STATE MARKERS AFTER ADD: $_namedMarkers");
    try {
      _buildMarkers();
    } catch (e) {
      throw ("Can not build for add marker: ${e.message}");
    }
    notify("updateMarkers", _markers);
  }

  Future<void> removeMarker({@required String name}) async {
    if (name == null) throw ArgumentError("name must not be null");
    //if (name != "livemarker") {
    //print("STATE REMOVE MARKER $name");
    //print("STATE MARKERS: $_namedMarkers");
    //}
    try {
      var res = _namedMarkers.remove(name);
      if (res == null) {
        throw ("Marker $name not found in map");
      }
    } catch (e) {
      throw ("Can not remove marker: ${e.message}");
    }
    try {
      _buildMarkers();
    } catch (e) {
      throw ("Can not build for remove marker: ${e.message}");
    }
    //print("STATE MARKERS AFTER REMOVE: $_namedMarkers");
    notify("updateMarkers", _markers);
  }

  void centerOnLiveMarker() {
    mapController.move(_liveMarker.point, mapController.zoom);
  }

  void _buildMarkers() {
    var listMarkers = <Marker>[];
    //print("BEFORE BUILD MARKERS");
    //_printMarkers();
    for (var k in _namedMarkers.keys) {
      //print("Adding $k: ${_namedMarkers[k]}");
      listMarkers.add(_namedMarkers[k]);
    }
    _markers = listMarkers;
    //print("AFTER BUILD MARKERS");
    //_printMarkers();
  }

  _printMarkers() {
    for (var k in _namedMarkers.keys) {
      print("NAMED MARKER $k: ${_namedMarkers[k]}");
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
