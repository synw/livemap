import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MarkersState {
  MarkersState(
      {@required this.mapController,
      @required this.center,
      @required this.zoom,
      @required this.notify})
      : assert(mapController != null),
        assert(center != null),
        assert(zoom != null);

  final MapController mapController;
  final LatLng center;
  final double zoom;
  final Function notify;

  List<Marker> markers = <Marker>[];

  updateMarkers(List<Marker> m) {
    print("UPDATING MARKERS =$m");
    markers = m;
    notify("updateMarkers", m);
  }

  addMarker(Marker m) {
    markers.add(m);
    updateMarkers(markers);
    notify("addMarker", m);
  }

  Marker buildLivemarker({LatLng position}) {
    num lat = mapController.ready ? mapController.center.latitude : center;
    num lon = mapController.ready ? mapController.center.longitude : center;
    LatLng _position = position ?? LatLng(lat, lon);
    return Marker(
      width: 80.0,
      height: 80.0,
      point: _position,
      builder: (ctx) => Container(
            child: Icon(
              Icons.directions,
              color: Colors.red,
            ),
          ),
    );
  }
}
