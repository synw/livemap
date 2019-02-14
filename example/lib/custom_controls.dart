import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geopoint/geopoint.dart';
import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';

class _CustomControlsPageState extends State<CustomControlsPage> {
  static final MapController mapController = MapController();
  static final LiveMapController liveMapController =
      LiveMapController(mapController: mapController);
  static final Stream<Position> positionStream =
      PositionStream(timeInterval: 3).stream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        LiveMap(
          positionStream: positionStream,
          mapController: mapController,
          liveMapController: liveMapController,
          liveMapOptions: LiveMapOptions(
            center: LatLng(51.0, 0.0),
            zoom: 17.0,
          ),
          titleLayer: TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
        ),
        Positioned(
          top: 35.0,
          right: 15.0,
          child: Column(
            children: <Widget>[
              IconButton(
                iconSize: 30.0,
                color: Colors.blueGrey,
                icon: const Icon(Icons.center_focus_strong),
                tooltip: "Center",
                onPressed: () => liveMapController.recenter(),
              ),
              IconButton(
                iconSize: 30.0,
                color: Colors.blueGrey,
                icon: Icon(Icons.center_focus_weak),
                tooltip: "Toggle autocenter",
                onPressed: () => _togglePositionStream(),
              ),
              IconButton(
                iconSize: 30.0,
                color: Colors.blueGrey,
                icon: _getliveMapStatusIcon(),
                tooltip: "Toggle live position updates",
                onPressed: () => _togglePositionStream(),
              ),
              IconButton(
                  iconSize: 30.0,
                  color: Colors.blueGrey,
                  icon: Icon(Icons.zoom_in),
                  tooltip: "Zoom in",
                  onPressed: () => liveMapController.zoomIn()),
              IconButton(
                  iconSize: 30.0,
                  color: Colors.blueGrey,
                  icon: Icon(Icons.zoom_out),
                  tooltip: "Zoom out",
                  onPressed: () => liveMapController.zoomOut()),
            ],
          ),
        )
      ],
    ));
  }

  _togglePositionStream() {
    setState(() {
      liveMapController.togglePositionStream();
    });
  }

  Icon _getliveMapStatusIcon() {
    Icon ic;
    liveMapController.positionStream.enabled
        ? ic = Icon(Icons.gps_not_fixed)
        : ic = Icon(Icons.gps_off);
    return ic;
  }
}

class CustomControlsPage extends StatefulWidget {
  @override
  _CustomControlsPageState createState() => _CustomControlsPageState();
}
