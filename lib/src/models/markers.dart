import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

class MarkersMap {
  Map<String, Marker> _markersMap = {};
  var _markers = <Marker>[];

  List<Marker> get markers => _markers;

  void add({@required Marker marker, @required String name}) {
    _markersMap[name] = marker;
    buildMarkers();
  }

  void remove({@required String name}) {
    _markersMap.remove(name);
    buildMarkers();
  }

  buildMarkers() {
    var lm = <Marker>[];
    _markersMap.forEach((_, m) => lm.add(m));
    _markers = lm;
  }
}
