import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geopoint/geopoint.dart';

class GeoMarkers {
  List<GeoMarker> _geoMarkers = [];
  List<Marker> _markers = [];

  List<Marker> get markers => _markers;

  void addGeoMarker(GeoMarker gm) {
    _geoMarkers.add(gm);
    buildMarkers();
  }

  void removeGeoMarkerFromName(String name) {
    _geoMarkers.removeWhere((_gm) => _gm.name == name);
    buildMarkers();
  }

  void removeGeoMarker(GeoMarker gm) {
    _geoMarkers.removeWhere((_gm) => _gm == gm);
    buildMarkers();
  }

  buildMarkers() {
    List<Marker> m = [];
    for (var gm in _geoMarkers) {
      m.add(gm.buildMarker());
    }
    _markers = m;
  }
}

class GeoMarker {
  GeoMarker(
      {@required this.name,
      @required this.point,
      @required this.builder,
      this.width,
      this.height})
      : assert(name != null),
        assert(point != null),
        assert(builder != null) {
    _marker = buildMarker();
  }

  Marker _marker;

  Marker get marker => _marker;

  GeoMarker.fromGeoPoint(
      {GeoPoint geoPoint,
      @required this.builder,
      @required this.width,
      @required this.height}) {
    point = geoPoint.point;
    name = geoPoint.name;
    _marker = buildMarker();
  }

  String name;
  LatLng point;
  final WidgetBuilder builder;
  final double width;
  final double height;

  Marker buildMarker() {
    return Marker(point: point, builder: builder, width: width, height: height);
  }
}
