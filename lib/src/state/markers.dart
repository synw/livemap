import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import '../models/markers.dart';

class MarkersState {
  MarkersState({@required this.mapController, @required this.notify})
      : assert(mapController != null);

  final MapController mapController;
  final Function notify;

  Marker _liveMarker = Marker(
      point: LatLng(0.0, 0.0),
      width: 80.0,
      height: 80.0,
      builder: _liveMarkerWidgetBuilder);

  MarkersMap _markersMap = MarkersMap();

  List<Marker> get markers => _markersMap.markers;

  void buildMarkers() {
    _markersMap.buildMarkers();
    notify("updateMarkers", markers);
  }

  void updateLiveGeoMarkerFromPosition(Position pos) {
    print("UPDATING LIVE MARKER FROM POS $pos");
    LatLng point = LatLng(pos.latitude, pos.longitude);
    _markersMap.remove(name: "livemarker");
    Marker lm = Marker(
        point: point,
        width: 80.0,
        height: 80.0,
        builder: _liveMarkerWidgetBuilder);
    _liveMarker = lm;
    _markersMap.add(marker: lm, name: "livemarker");
    notify("updateMarkers", markers);
  }

  void addMarker(Marker marker, String name) {
    _markersMap.add(marker: marker, name: name);
    notify("updateMarkers", markers);
  }

  void removeMarker(String name) {
    _markersMap.remove(name: name);
    notify("updateMarkers", markers);
  }

  void centerOnLiveMarker() {
    mapController.move(_liveMarker.point, mapController.zoom);
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
