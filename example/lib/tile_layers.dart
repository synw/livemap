import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';

class TileLayerLiveMapPage extends StatefulWidget {
  @override
  _TileLayerLiveMapPageState createState() => _TileLayerLiveMapPageState();
}

class _TileLayerLiveMapPageState extends State<TileLayerLiveMapPage> {
  _TileLayerLiveMapPageState() {
    mapController = MapController();
    liveMapController =
        LiveMapController(autoCenter: true, mapController: mapController);
  }

  MapController mapController;
  LiveMapController liveMapController;

  @override
  void dispose() {
    liveMapController.dispose();
    super.dispose();
    liveMapController.onLiveMapReady
        .then((_) => liveMapController.centerOnLiveMarker());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        LiveMap(
          liveMapController: liveMapController,
          mapOptions: MapOptions(
            center: LatLng(51.0, 0.0),
            zoom: 17.0,
          ),
        ),
        Positioned(
          top: 35.0,
          right: 20.0,
          child: TileLayersBar(controller: liveMapController),
        ),
      ],
    ));
  }
}
