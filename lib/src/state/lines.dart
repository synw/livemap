import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class LinesState {
  LinesState({@required this.notify}) : assert(notify != null);

  final Function notify;

  Map<String, Polyline> _namedLines = {};

  List<Polyline> get lines => _namedLines.values.toList();

  Future<void> addLine(
      {@required String name,
      @required List<LatLng> points,
      double width = 1.0,
      Color color = Colors.green,
      bool isDotted = false}) async {
    //print("ADD LINE $name of ${points.length} points");
    _namedLines[name] = Polyline(
        points: points, strokeWidth: width, color: color, isDotted: isDotted);
    notify("updateLines", _namedLines[name], addLine);
  }
}
