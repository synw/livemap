import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import '../models/geomarker.dart';

class MarkersState {
  MarkersState({@required this.mapController, @required this.notify})
      : assert(mapController != null);

  final MapController mapController;
  final Function notify;

  GeoMarker _geoLiveMarker = GeoMarker(
      name: "livemarker",
      point: LatLng(0.0, 0.0),
      width: 80.0,
      height: 80.0,
      builder: _liveMarkerWidgetBuilder);
  GeoMarkers _geoMarkers = GeoMarkers();

  List<Marker> get markers => _geoMarkers.markers;

  void buildMarkers() {
    _geoMarkers.buildMarkers();
    notify("updateMarkers", _geoMarkers.markers);
  }

  void updateLiveGeoMarkerFromPosition(Position pos) {
    print("UPDATING LIVE MARKER FROM POS $pos");
    LatLng point = LatLng(pos.latitude, pos.longitude);
    _geoMarkers.removeGeoMarker(_geoLiveMarker);
    _geoLiveMarker.point = point;
    _geoMarkers.addGeoMarker(_geoLiveMarker);
    notify("updateMarkers", _geoMarkers.markers);
  }

  void addGeoMarker(GeoMarker geoMarker) {
    _geoMarkers.addGeoMarker(geoMarker);
    notify("updateMarkers", _geoMarkers.markers);
  }

  void removeGeoMarkerFromName(String name) {
    _geoMarkers.removeGeoMarkerFromName(name);
    notify("updateMarkers", _geoMarkers.markers);
  }

  void centerOnLiveMarker() {
    mapController.move(_geoLiveMarker.point, mapController.zoom);
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
