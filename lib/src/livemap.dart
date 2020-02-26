import 'package:flutter/material.dart';
import 'package:fluxmap/fluxmap.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'controller.dart';

class _LiveMapState extends State<LiveMap> {
  _LiveMapState(
      {@required this.controller,
      this.center,
      this.zoom = 2.0,
      this.extraLayers = const <LayerOptions>[]})
      : assert(controller != null) {
    center ??= LatLng(0.0, 0.0);
  }

  LiveMapController controller;
  LatLng center;
  final double zoom;
  final List<LayerOptions> extraLayers;

  @override
  Widget build(BuildContext context) {
    return FluxMap(
        state: controller.flux,
        devicesFlux: controller.devicesFlux.stream,
        networkStatusLoop: false,
        center: center,
        zoom: zoom,
        extraLayers: extraLayers);
  }
}

/// The main livemap class
class LiveMap extends StatefulWidget {
  /// Provide a controller
  const LiveMap(
      {@required this.controller,
      this.center,
      this.zoom = 2.0,
      this.extraLayers = const <LayerOptions>[]});

  /// The map controller
  final LiveMapController controller;

  /// The default center
  final LatLng center;

  /// The default zoom
  final double zoom;

  /// Extra map layers
  final List<LayerOptions> extraLayers;

  @override
  _LiveMapState createState() =>
      _LiveMapState(controller: controller, center: center, zoom: zoom);
}
