import 'dart:async';
import 'package:flutter/material.dart';
import '../controller.dart';
import '../types.dart';

class _TileLayersBarState extends State<TileLayersBar> {
  _TileLayersBarState({@required this.controller});

  final LiveMapController controller;

  TileLayerType _tileLayerType;
  StreamSubscription<TileLayerType> _sub;

  Widget _buildLayers() {
    return Column(children: <Widget>[
      IconButton(
        iconSize: 30.0,
        color: (_tileLayerType == TileLayerType.normal)
            ? Colors.blueGrey
            : Colors.grey,
        icon: const Icon(Icons.map),
        tooltip: "Normal layer",
        onPressed: () => controller.switchTileLayer(TileLayerType.normal),
      ),
      IconButton(
        iconSize: 30.0,
        color: (_tileLayerType == TileLayerType.monochrome)
            ? Colors.blueGrey
            : Colors.grey,
        icon: const Icon(Icons.local_car_wash),
        tooltip: "Monochrome layer",
        onPressed: () => controller.switchTileLayer(TileLayerType.monochrome),
      ),
      IconButton(
        iconSize: 30.0,
        color: (_tileLayerType == TileLayerType.topography)
            ? Colors.blueGrey
            : Colors.grey,
        icon: const Icon(Icons.photo),
        tooltip: "Topography layer",
        onPressed: () => controller.switchTileLayer(TileLayerType.topography),
      ),
      IconButton(
        iconSize: 30.0,
        color: (_tileLayerType == TileLayerType.hike)
            ? Colors.blueGrey
            : Colors.grey,
        icon: const Icon(Icons.landscape),
        tooltip: "Hills layer",
        onPressed: () => controller.switchTileLayer(TileLayerType.hike),
      ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    _sub = controller.tileLayerChangeFeed
        .listen((tl) => setState(() => _tileLayerType = tl));
  }

  @override
  Widget build(BuildContext context) => _buildLayers();

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

class TileLayersBar extends StatefulWidget {
  TileLayersBar({@required this.controller});

  final LiveMapController controller;

  @override
  _TileLayersBarState createState() =>
      _TileLayersBarState(controller: controller);
}
