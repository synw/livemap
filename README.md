# Livemap

A map widget with live position updates. Based on [Flutter map](https://github.com/johnpryan/flutter_map) and [Geolocator](https://github.com/BaseflowIT/flutter-geolocator). Provides a controller api to handle map state changes.

## Controller api

Api for the `LiveMapController` class

### Map controls

#### Zoom

**`zoom`**: get the current zoom value

**`zoomIn()`**: increase the zoom level by 1

**`zoomOut()`**: decrease the zoom level by 1

**`setZoom`**(`double` *zoomLevel* ): set the zoom to the given zoom level

#### Center

**`center`**: get the current center `LatLng` value

**`centerOnPosition`**(`Position` *position* ): center the map on a `Position`

**`centerOnLiveMarker()`**: recenter the map on the live position marker

**`autoCenterEnabled`**: get the current value of autocenter: used when the position updates are on

**`toggleAutoCenter()`**: toggle the value of autocenter

### Position stream status

**`positionStreamEnabled`**: get the status of the live position stream

**`togglePositionStreamSubscription()`**: enable or disable the live position stream

### Changefeed

A changefeed is available: it's a stream with all state changes from the map controller. Ex:

   ```dart
   import 'dart:async';

   StreamSubscription _changefeed;

   mapController.onReady.then((_) {
       _changefeed = liveMapController.changeFeed.listen((change) {
        if (change.name == "zoom") {
          setState(() {
              _myzoom = change.value;
          });
        }
      });
   }

   // _changefeed.cancel();
   ```


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

  @override
  void dispose() {
    liveMapController.dispose();
    super.dispose();
  }
}
   ```

