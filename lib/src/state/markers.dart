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

  LatLng liveMarkerPosition = LatLng(0.0, 0.0);

  List<Marker> markers = <Marker>[];

  void updateLiveMarkerFromPosition(Position pos) {
    print("UPDATING MARKERS =$pos");
    LatLng point = LatLng(pos.latitude, pos.longitude);
    liveMarkerPosition = point;
    markers = [buildLivemarker()];
    notify("updateMarkers", markers);
  }

  void centerOnLiveMarker() {
    mapController.move(liveMarkerPosition, mapController.zoom);
  }

  Marker buildLivemarker() {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: liveMarkerPosition,
      builder: (ctx) => Container(
            child: Icon(
              Icons.directions,
              color: Colors.red,
            ),
          ),
    );
  }
}
