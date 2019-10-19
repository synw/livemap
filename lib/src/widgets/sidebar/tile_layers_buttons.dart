import 'dart:async';
import 'package:flutter/material.dart';
import '../../controller.dart';
import '../../types.dart';

class _MapTileLayerNormalState extends State<MapTileLayerNormal> {
  _MapTileLayerNormalState({@required this.liveMapController});

  final LiveMapController liveMapController;

  TileLayerType _tileLayerType;
  StreamSubscription<TileLayerType> _sub;

  @override
  void initState() {
    super.initState();
    _sub = liveMapController.tileLayerChangeFeed
        .listen((tl) => setState(() => _tileLayerType = tl));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30.0,
      color: (_tileLayerType == TileLayerType.normal)
          ? Colors.blueGrey
          : Colors.grey,
      icon: const Icon(Icons.map),
      tooltip: "Normal layer",
      onPressed: () =>
          widget.liveMapController.switchTileLayer(TileLayerType.normal),
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

class MapTileLayerNormal extends StatefulWidget {
  MapTileLayerNormal({@required this.liveMapController});

  final LiveMapController liveMapController;

  @override
  _MapTileLayerNormalState createState() =>
      _MapTileLayerNormalState(liveMapController: liveMapController);
}

class _MapTileLayerMonochromeState extends State<MapTileLayerMonochrome> {
  _MapTileLayerMonochromeState({@required this.liveMapController});

  final LiveMapController liveMapController;

  TileLayerType _tileLayerType;
  StreamSubscription<TileLayerType> _sub;

  @override
  void initState() {
    super.initState();
    _sub = liveMapController.tileLayerChangeFeed
        .listen((tl) => setState(() => _tileLayerType = tl));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30.0,
      color: (_tileLayerType == TileLayerType.monochrome)
          ? Colors.blueGrey
          : Colors.grey,
      icon: const Icon(Icons.local_car_wash),
      tooltip: "Monochrome layer",
      onPressed: () =>
          liveMapController.switchTileLayer(TileLayerType.monochrome),
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

class MapTileLayerMonochrome extends StatefulWidget {
  MapTileLayerMonochrome({@required this.liveMapController});

  final LiveMapController liveMapController;

  @override
  _MapTileLayerMonochromeState createState() =>
      _MapTileLayerMonochromeState(liveMapController: liveMapController);
}

class _MapTileLayerTopographyState extends State<MapTileLayerTopography> {
  _MapTileLayerTopographyState({@required this.liveMapController});

  final LiveMapController liveMapController;

  TileLayerType _tileLayerType;
  StreamSubscription<TileLayerType> _sub;

  @override
  void initState() {
    super.initState();
    _sub = liveMapController.tileLayerChangeFeed
        .listen((tl) => setState(() => _tileLayerType = tl));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30.0,
      color: (_tileLayerType == TileLayerType.topography)
          ? Colors.blueGrey
          : Colors.grey,
      icon: const Icon(Icons.photo),
      tooltip: "Topography layer",
      onPressed: () =>
          liveMapController.switchTileLayer(TileLayerType.topography),
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

class MapTileLayerTopography extends StatefulWidget {
  MapTileLayerTopography({@required this.liveMapController});

  final LiveMapController liveMapController;

  @override
  _MapTileLayerTopographyState createState() =>
      _MapTileLayerTopographyState(liveMapController: liveMapController);
}

class _MapTileLayerHikeState extends State<MapTileLayerHike> {
  _MapTileLayerHikeState({@required this.liveMapController});

  final LiveMapController liveMapController;

  TileLayerType _tileLayerType;
  StreamSubscription<TileLayerType> _sub;

  @override
  void initState() {
    super.initState();
    _sub = liveMapController.tileLayerChangeFeed
        .listen((tl) => setState(() => _tileLayerType = tl));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30.0,
      color: (_tileLayerType == TileLayerType.hike)
          ? Colors.blueGrey
          : Colors.grey,
      icon: const Icon(Icons.landscape),
      tooltip: "Hills layer",
      onPressed: () => liveMapController.switchTileLayer(TileLayerType.hike),
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

class MapTileLayerHike extends StatefulWidget {
  MapTileLayerHike({@required this.liveMapController});

  final LiveMapController liveMapController;

  @override
  _MapTileLayerHikeState createState() =>
      _MapTileLayerHikeState(liveMapController: liveMapController);
}
