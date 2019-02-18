import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class PopMarker {
  PopMarker(
      {@required this.name,
      @required this.point,
      @required this.builder,
      this.width,
      this.height})
      : assert(name != null),
        assert(point != null),
        assert(builder != null);

  final name;
  final LatLng point;
  final WidgetBuilder builder;
  final double width;
  final double height;

  Marker get marker => _build();

  Marker _build() {
    return Marker(point: point, builder: builder, width: width, height: height);
  }
}
