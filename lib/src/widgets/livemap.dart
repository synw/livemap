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
    liveMapController.onLiveMapReady.then((_) {
      debugPrint("MAP IS READY");
      _changefeed = liveMapController.changeFeed.listen((change) {
        if (change.name == "updateMarkers" ||
            change.name == "updateLines" ||
            change.name == "updatePolygons") {
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
        PolygonLayerOptions(
          polygons: liveMapController.polygons,
        ),
        PolylineLayerOptions(
          polylines: liveMapController.lines,
        ),
        MarkerLayerOptions(
          markers: liveMapController.markers,
        ),
      ],
    );
  }
}

/// The main map widget
class LiveMap extends StatefulWidget {
  /// Provide a [MapController] and a [LiveMapController]
  LiveMap(
      {@required this.mapController,
      @required this.liveMapController,
      this.titleLayer,
      this.mapOptions});

  /// The Flutter Map [MapOptions]
  final MapOptions mapOptions;

  /// The Flutter Map [TileLayer]
  final TileLayerOptions titleLayer;

  /// The Flutter Map [MapController]
  final MapController mapController;

  /// The [LiveMapController]
  final LiveMapController liveMapController;

  @override
  _LiveMapState createState() => _LiveMapState(
      mapOptions: mapOptions,
      titleLayer: titleLayer,
      mapController: mapController,
      liveMapController: liveMapController);
}
