import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../controller.dart';

class MapCenterOnLiveMarker extends StatelessWidget {
  MapCenterOnLiveMarker({@required this.liveMapController});

  final LiveMapController liveMapController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 30.0,
        color: Colors.blueGrey,
        icon: const Icon(Icons.crop_free),
        tooltip: "Center",
        onPressed: () => liveMapController.centerOnLiveMarker());
  }
}

class MapToggleAutoCenter extends StatelessWidget {
  MapToggleAutoCenter({@required this.liveMapController});

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

class MapTogglePositionStream extends StatefulWidget {
  MapTogglePositionStream({@required this.liveMapController});

  final LiveMapController liveMapController;

  @override
  _MapTogglePositionStreamState createState() =>
      _MapTogglePositionStreamState(liveMapController: liveMapController);
}

class MapZoomIn extends StatelessWidget {
  MapZoomIn({@required this.liveMapController});

  final LiveMapController liveMapController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 30.0,
        color: Colors.blueGrey,
        icon: const Icon(Icons.zoom_in),
        tooltip: "Zoom in",
        onPressed: () => liveMapController.zoomIn());
  }
}

class MapZoomOut extends StatelessWidget {
  MapZoomOut({@required this.liveMapController});

  final LiveMapController liveMapController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 30.0,
        color: Colors.blueGrey,
        icon: const Icon(Icons.zoom_out),
        tooltip: "Zoom out",
        onPressed: () => liveMapController.zoomOut());
  }
}
