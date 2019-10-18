import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import '../controller.dart';
import '../types.dart';

class _LiveMapState extends State<LiveMap> {
  _LiveMapState(
      {@required this.mapController,
      @required this.liveMapController,
      @required this.mapOptions,
      this.tileLayer,
      this.layer})
      : assert(mapController != null),
        assert(liveMapController != null) {
    if (tileLayer == null) {
      layer ??= TileLayerType.normal;
      setTileLayer(layer);
    }
  }

  final MapController mapController;
  final LiveMapController liveMapController;
  final MapOptions mapOptions;
  final TileLayerOptions tileLayer;
  TileLayerType layer;

  StreamSubscription _changefeedSub;
  StreamSubscription _tileLayerChangefeedSub;
  TileLayerOptions _tileLayer;

  void setTileLayer(TileLayerType lt) {
    if (tileLayer != null) {
      _tileLayer = tileLayer;
    } else {
      switch (lt) {
        case TileLayerType.hike:
          _tileLayer = TileLayerOptions(
              urlTemplate: "https://tiles.wmflabs.org/hikebike/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']);
          break;
        case TileLayerType.topography:
          _tileLayer = TileLayerOptions(
              urlTemplate: "http://{s}.tile.opentopomap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']);
          break;
        case TileLayerType.monochrome:
          _tileLayer = TileLayerOptions(
              urlTemplate:
                  "http://www.toolserver.org/tiles/bw-mapnik/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']);
          break;
        default:
          _tileLayer = TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']);
      }
    }
  }

  void watchTileLayerChange() =>
      _tileLayerChangefeedSub = _tileLayerChangefeedSub =
          liveMapController.tileLayerChangeFeed.listen((tl) {
        print("TILE LAYER CHANGE $tl");
        setState(() {
          setTileLayer(tl);
        });
      });

  @override
  void initState() {
    liveMapController.onLiveMapReady.then((_) {
      debugPrint("MAP IS READY");
      _changefeedSub =
          liveMapController.changeFeed.listen((change) => setState(() {}));
      watchTileLayerChange();
    });
    super.initState();
  }

  @override
  void dispose() {
    _changefeedSub.cancel();
    _tileLayerChangefeedSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: mapOptions,
      layers: [
        _tileLayer,
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
  /// Provide a [LiveMapController]
  LiveMap(
      {@required this.liveMapController,
      this.tileLayer,
      this.layer,
      this.mapOptions})
      : mapController = liveMapController.mapController;

  /// The Flutter Map [MapOptions]
  final MapOptions mapOptions;

  /// The Flutter Map [TileLayerType]
  final TileLayerOptions tileLayer;

  /// The Flutter Map [MapController]
  final MapController mapController;

  /// The [LiveMapController]
  final LiveMapController liveMapController;

  /// A predefined tile layer type
  final TileLayerType layer;

  @override
  _LiveMapState createState() => _LiveMapState(
      mapOptions: mapOptions,
      tileLayer: tileLayer,
      layer: layer,
      mapController: mapController,
      liveMapController: liveMapController);
}
