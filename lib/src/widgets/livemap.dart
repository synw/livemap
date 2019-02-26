import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import '../controller.dart';

class _LiveMapState extends State<LiveMap> {
  _LiveMapState({
    @required this.mapController,
    @required this.liveMapController,
    @required this.titleLayer,
    @required this.mapOptions,
  })  : assert(mapController != null),
        assert(liveMapController != null),
        assert(titleLayer != null);

  final MapController mapController;
  final LiveMapController liveMapController;
  final MapOptions mapOptions;
  final TileLayerOptions titleLayer;

  StreamSubscription _changefeed;

  @override
  void initState() {
    mapController.onReady.then((_) {
      print("MAP IS READY");
      _changefeed = liveMapController.changeFeed.listen((change) {
        if (change.name == "updateMarkers") {
          //print("SET STATE MARKERS");
          setState(() {});
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _changefeed.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: mapOptions,
      layers: [
        titleLayer,
        MarkerLayerOptions(
          markers: liveMapController.markers,
        ),
      ],
    );
  }
}

class LiveMap extends StatefulWidget {
  LiveMap(
      {@required this.mapController,
      @required this.liveMapController,
      this.titleLayer,
      this.mapOptions});

  final MapOptions mapOptions;
  final TileLayerOptions titleLayer;
  final MapController mapController;
  final LiveMapController liveMapController;

  @override
  _LiveMapState createState() => _LiveMapState(
      mapOptions: mapOptions,
      titleLayer: titleLayer,
      mapController: mapController,
      liveMapController: liveMapController);
}
