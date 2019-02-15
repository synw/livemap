import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class LiveMapOptions extends MapOptions {
  final Crs crs;
  final double zoom;
  final double minZoom;
  final double maxZoom;
  final List<LayerOptions> layers;
  final bool debug;
  final bool interactive;
  TapCallback onTap;
  PositionCallback onPositionChanged;
  final List<MapPlugin> plugins;
  LatLng center;
  LatLng swPanBoundary;
  LatLng nePanBoundary;

  get mapOptions => _buildMapOptions();

  LiveMapOptions({
    this.crs: const Epsg3857(),
    this.center,
    this.zoom = 13.0,
    this.minZoom,
    this.maxZoom,
    this.layers,
    this.debug = false,
    this.interactive = true,
    this.onTap,
    this.onPositionChanged,
    this.plugins = const [],
    this.swPanBoundary,
    this.nePanBoundary,
  }) {
    this.onPositionChanged = onPositionChanged ?? _onPositionChanged;
  }

  _onPositionChanged(MapPosition mapPosition, bool hasGesture) {
    if (hasGesture == true) {
      print("GESTURE");
    } else {
      print("ON POSITION CHANGED");
    }
  }

  MapOptions _buildMapOptions() {
    return MapOptions(
        crs: crs,
        center: center,
        zoom: zoom,
        minZoom: minZoom,
        maxZoom: maxZoom,
        layers: layers,
        debug: debug,
        interactive: interactive,
        onTap: onTap,
        onPositionChanged: onPositionChanged,
        plugins: plugins,
        swPanBoundary: swPanBoundary,
        nePanBoundary: swPanBoundary);
  }
}
