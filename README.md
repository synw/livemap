# Livemap

[![pub package](https://img.shields.io/pub/v/livemap.svg)](https://pub.dartlang.org/packages/livemap)

A map widget with live position updates. Based on [Flutter map](https://github.com/johnpryan/flutter_map) and [Geolocator](https://github.com/BaseflowIT/flutter-geolocator). Provides a controller api to handle map state changes.

![Screenshot](screenshot.gif)

## Map controller

Api for the `LiveMapController` class

### Basic map controls

For basic map controls like center, zoom, add an asset on the map see the
[Map controller](https://github.com/synw/map_controller) documentation

### Livemap controls

#### Center

**`centerOnPosition`**(`Position` *position* ): center the map on a `Position`

**`centerOnLiveMarker()`**: recenter the map on the live position marker

**`toggleAutoCenter()`**: toggle the value of autocenter

**`autoCenter`**: get the current value of autocenter: used when the position updates are on

### Rotation

**`autoRotate`**: automatically rotate the map from bearing

**`rotate`**(`double` degrees): rotate the map

### Position stream

**`togglePositionStreamSubscription()`**: enable or disable the live position stream

## On ready callback

Execute code right after the map is ready:

   ```dart
   @override
   void initState() {
      liveMapController.onLiveMapReady.then((_) {
         liveMapController.togglePositionStreamSubscription();
      });
      super.initState();
   }
   ```

## Sidebar

Use the `LiveMapSideBar` widget or compose your own sidebar:

   ```dart
   /// in a [Stack] widget
   Positioned(
      top: 35.0,
      right: 15.0,
      child: Column(children: <Widget>[
         MapCenterOnLiveMarker(liveMapController: liveMapController),
         MapToggleAutoCenter(liveMapController: liveMapController),
         MapTogglePositionStream(liveMapController: liveMapController),
         MapZoomIn(liveMapController: liveMapController),
         MapZoomOut(liveMapController: liveMapController),
      ])
   )
   ```

## Tile layers

Some open tile layers and a tile switcher bar are available:

   ```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        LiveMap(
          /// defaults the [tileLayer] property to [TileLayerType.normal]
          liveMapController: liveMapController,
          mapOptions: MapOptions(
            center: LatLng(51.0, 0.0),
            zoom: 17.0)),
        Positioned(
          top: 35.0,
          right: 20.0,
          child: TileLayersBar(controller: liveMapController)),
      ],
    ));
  }
   ```

Available layers:

   ```dart
   enum TileLayerType { normal, topography, monochrome, hike }
   ```

Custom tile layers bar:

   ```dart
   Positioned(
      top: 35.0,
      right: 15.0,
      child: Column(children: <Widget>[
         // .. other buttons
         MapTileLayerNormal(liveMapController: livemapController),
         MapTileLayerMonochrome(liveMapController: livemapController),
         MapTileLayerTopography(liveMapController: livemapController),
         MapTileLayerHike(liveMapController: livemapController),
      ])
   )
   ```

## Example

   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_map/flutter_map.dart';
   import 'package:geolocator/geolocator.dart';
   import 'package:livemap/livemap.dart';
   import 'package:latlong/latlong.dart';

   class LiveMapPage extends StatelessWidget {
     LiveMapPage() () {
       mapController = MapController();
       liveMapController = LiveMapController(
         mapController:   mapController,
         autoCenter: true);
     }

     MapController mapController;
     LiveMapController liveMapController;

     @override
     Widget build(BuildContext context) {
       return Scaffold(
           body: LiveMap(
             liveMapController: liveMapController,
             mapOptions: MapOptions(
               center: LatLng(51.0, 0.0),
               zoom: 13.0),
             titleLayer: TileLayerOptions(
                 urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                 subdomains: ['a', 'b', 'c']),
           ));
     }

     @override
     void dispose() {
       liveMapController.dispose();
       super.dispose();
     }
   }
   ```

### Changefeed

A changefeed is available: it's a stream with all state changes from the map controller. Ex:

   ```dart
   import 'dart:async';

   StreamSubscription _changefeed;
   int _myzoom;

   liveMapController.onReady.then((_) {
       _myzoom = liveMapController.zoom;
       _changefeed = liveMapController.changeFeed.listen((change) {
        if (change.name == "zoom") {
          print("New zoom value: ${change.value}")
        }
      });
   }

   // dispose: _changefeed.cancel();
   ```
