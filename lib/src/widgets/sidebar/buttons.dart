import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../controller.dart';

/// A toggle center on live marker button
class MapCenterOnLiveMarker extends StatelessWidget {
  /// Provide a controller
  const MapCenterOnLiveMarker({@required this.liveMapController});

  /// The map controller
  final LiveMapController liveMapController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 30.0,
        color: Colors.blueGrey,
        icon: const Icon(Icons.crop_free),
        tooltip: "Center",
        onPressed: liveMapController.centerOnLiveMarker);
  }
}

/// A toggle autocenter button
class MapToggleAutoCenter extends StatelessWidget {
  /// Provide a controller
  const MapToggleAutoCenter({@required this.liveMapController});

  /// The map controller
  final LiveMapController liveMapController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30.0,
      color: Colors.blueGrey,
      icon: const Icon(Icons.center_focus_weak),
      tooltip: "Toggle autocenter",
      onPressed: () {
        liveMapController.toggleAutoCenter();
        Fluttertoast.showToast(
          msg: liveMapController.autoCenter
              ? "Auto center activated"
              : "Auto center deactivated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      },
    );
  }
}

class _MapTogglePositionStreamState extends State<MapTogglePositionStream> {
  _MapTogglePositionStreamState({@required this.liveMapController});

  final LiveMapController liveMapController;

  bool _positionStreamEnabled;
  StreamSubscription _changeFeedSub;

  @override
  void initState() {
    _positionStreamEnabled = liveMapController.positionStreamEnabled;
    _changeFeedSub = liveMapController.changeFeed.listen((change) {
      if (change.name == "positionStream") {
        setState(() {
          _positionStreamEnabled = (change.value == true) ? true : false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30.0,
      color: Colors.blueGrey,
      icon: _positionStreamEnabled
          ? const Icon(Icons.gps_not_fixed)
          : const Icon(Icons.gps_off),
      tooltip: "Toggle live position updates",
      onPressed: () {
        liveMapController.togglePositionStreamSubscription();
        Fluttertoast.showToast(
          msg: (liveMapController.positionStreamEnabled)
              ? "Position updates enabled"
              : "Position updates disabled",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      },
    );
  }

  @override
  void dispose() {
    _changeFeedSub.cancel();
    super.dispose();
  }
}

/// A toggle position stream button
class MapTogglePositionStream extends StatefulWidget {
  /// Provide a controller
  const MapTogglePositionStream({@required this.liveMapController});

  /// The map controller
  final LiveMapController liveMapController;

  @override
  _MapTogglePositionStreamState createState() =>
      _MapTogglePositionStreamState(liveMapController: liveMapController);
}

/// A zoom in button
class MapZoomIn extends StatelessWidget {
  /// Provide a controller
  const MapZoomIn({@required this.liveMapController});

  /// The map controller
  final LiveMapController liveMapController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 30.0,
        color: Colors.blueGrey,
        icon: const Icon(Icons.zoom_in),
        tooltip: "Zoom in",
        onPressed: liveMapController.zoomIn);
  }
}

/// A zoom out button
class MapZoomOut extends StatelessWidget {
  /// Provide a controller
  const MapZoomOut({@required this.liveMapController});

  /// The map controller
  final LiveMapController liveMapController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 30.0,
        color: Colors.blueGrey,
        icon: const Icon(Icons.zoom_out),
        tooltip: "Zoom out",
        onPressed: liveMapController.zoomOut);
  }
}
