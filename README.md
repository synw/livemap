# Livemap

A map widget with live posision updates. Based on [Flutter map](https://github.com/johnpryan/flutter_map) and [Geolocator](https://github.com/BaseflowIT/flutter-geolocator)

## Example

   ```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';

class LiveMapPage extends StatelessWidget {
  static final MapController mapController = MapController();
  static final Stream<Position> positionStream = 
      PositionStream(distanceFilter: 10).stream;
  static final LiveMapController liveMapController =
      LiveMapController(mapController: mapController,
          positionStream: positionStream);

  

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

Api for `LiveMapController`

### Zoom

**`zoom`**: get the current zoom value

**`zoomIn()`**: increase the zoom level by 1

**`zoomOut()`**: decrease the zoom level by 1

**`setZoom`**(`num` *zoomLevel* ): set the zoom to the given zoom level

### Center

**`center`**: get the current center `LatLng` value

**`centerOnPosition`**(`Position` *position* ): center the map on a `Position`

**`recenter`**(): recenter the map on the last current position

**`autoCenterEnabled`**: get the current value of autocenter: used when the position updates are on

**`toggleAutoCenter`**(): toggle the value of autocenter

### Position stream status

**`togglePositionStreamSubscription()`**: enable or disable the live position stream




