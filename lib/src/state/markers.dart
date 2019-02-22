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

  Map<String, Marker> _mapMarkers = {};
  var _markers = <Marker>[];
  Marker _liveMarker = Marker(
      point: LatLng(0.0, 0.0),
      width: 80.0,
      height: 80.0,
      builder: _liveMarkerWidgetBuilder);

  List<Marker> get markers => _markers;

  void updateLiveGeoMarkerFromPosition({@required Position position}) {
    if (position == null) throw ArgumentError("position must not be null");
    print("UPDATING LIVE MARKER FROM POS $position");
    LatLng point = LatLng(position.latitude, position.longitude);
    removeMarker(name: "livemarker");
    Marker lm = Marker(
        point: point,
        width: 80.0,
        height: 80.0,
        builder: _liveMarkerWidgetBuilder);
    _liveMarker = lm;
    addMarker(marker: lm, name: "livemarker");
  }

  void addMarker({@required Marker marker, @required String name}) {
    if (marker == null) throw ArgumentError("marker must not be null");
    if (name == null) throw ArgumentError("name must not be null");
    _mapMarkers[name] = marker;
    _buildMarkers();
    notify("updateMarkers", _markers);
  }

  void removeMarker({@required String name}) {
    if (name == null) throw ArgumentError("name must not be null");
    _mapMarkers.remove(name);
    _buildMarkers();
    notify("updateMarkers", _markers);
  }

  void centerOnLiveMarker() {
    mapController.move(_liveMarker.point, mapController.zoom);
  }

  void _buildMarkers() {
    var lm = <Marker>[];
    _mapMarkers.forEach((_, m) => lm.add(m));
    _markers = lm;
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
