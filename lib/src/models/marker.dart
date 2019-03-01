import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';
import '../controller.dart';
import 'bubble_marker.dart';

Marker buildDefaultMarker(
    {@required String name,
    @required LatLng point,
    @required LiveMapController liveMapController}) {
  return Marker(
      width: 90,
      height: 90,
      point: point,
      builder: (_) {
        return BubbleMarker(
          name: name,
          point: point,
          isPoped: false,
          onDoubleTap: (_) => {},
          onTap: (_) {
            print("LONG PRESS");
            liveMapController.removeMarker(name: name);
          },
        );
      });
}
