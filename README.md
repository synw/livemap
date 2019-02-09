# Livemap

A map widget with live posision updates. Based on [Flutter map](https://github.com/johnpryan/flutter_map) and [Geolocator](https://github.com/BaseflowIT/flutter-geolocator)

## Example

   ```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';

class LiveMapPage extends StatelessWidget {
  static final MapController mapController = MapController();
  static final LiveMapController liveMapController =
      LiveMapController(mapController: mapController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LiveMap(
          mapController: mapController,
          liveMapController: liveMapController,
          mapOptions: MapOptions(
            center: LatLng(51.0, 0.0),
            zoom: 13.0,
          ),
          titleLayer: TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
        ),
        bottomNavigationBar: LiveMapBottomNavigationBar(
          liveMapController: liveMapController,
        ));
  }
}
   ```

## Controller api

Api for `LiveMapController`:

### Zoom

**`liveMapController.zoomIn()`**: increase the zoom level by 1

**`liveMapController.zoomOut()`**: decrease the zoom level by 1

**`liveMapController.setZoom`**(`num` *zoomLevel* ): set the zoom to the give zoom level

### Center

**`liveMapController.centerOnPosition`**(`Position` *position* ): center the map on a `Position`

**`liveMapController.setCenter`**(`LatLng` *coordinates* ): center the map on the given `LatLng` coordinates

### Position stream status

**`liveMapController.togglePositionStream`()**: enable or disable the live position stream




