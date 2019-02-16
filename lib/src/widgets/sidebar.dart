import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../controller.dart';

class _LiveMapSideBarState extends State<LiveMapSideBar> {
  _LiveMapSideBarState({
    @required this.liveMapController,
    this.bottom,
    this.left,
    this.right,
    this.top,
    this.onPressedAutoCenter,
    this.messages,
  }) : assert(liveMapController != null) {
    onPressedAutoCenter = onPressedAutoCenter ?? () => {};
    messages = messages ?? true;
    (top == null && bottom == null) ? top = 35.0 : top = top;
    (right == null && left == null) ? right = 20.0 : right = right;
  }

  final LiveMapController liveMapController;
  double top;
  double right;
  final double bottom;
  final double left;
  VoidCallback onPressedAutoCenter;
  bool messages;

  bool _positionStreamEnabled;
  StreamSubscription _changeFeedSub;

  @override
  void initState() {
    _positionStreamEnabled = liveMapController.positionStream.enabled;
    _changeFeedSub = liveMapController.changeFeed.listen((change) {
      if (change.name == "positionStream")
        setState(() {
          _positionStreamEnabled = change.value;
        });
    });
    super.initState();
  }

  @override
  void dispose() {
    _changeFeedSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Column(
        children: <Widget>[
          IconButton(
            iconSize: 30.0,
            color: Colors.blueGrey,
            icon: const Icon(Icons.center_focus_strong),
            tooltip: "Center",
            onPressed: () => liveMapController.recenter(),
          ),
          IconButton(
            iconSize: 30.0,
            color: Colors.blueGrey,
            icon: Icon(Icons.center_focus_weak),
            tooltip: "Toggle autocenter",
            onPressed: _onPressedAutoCenter,
          ),
          IconButton(
            iconSize: 30.0,
            color: Colors.blueGrey,
            icon: _positionStreamEnabled
                ? Icon(Icons.gps_not_fixed)
                : Icon(Icons.gps_off),
            tooltip: "Toggle live position updates",
            onPressed: () {
              liveMapController.togglePositionStream();
              Fluttertoast.showToast(
                msg: (liveMapController.positionStream.enabled)
                    ? "Position updates enabled"
                    : "Position updates disabled",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
          ),
          IconButton(
              iconSize: 30.0,
              color: Colors.blueGrey,
              icon: Icon(Icons.zoom_in),
              tooltip: "Zoom in",
              onPressed: () => liveMapController.zoomIn()),
          IconButton(
              iconSize: 30.0,
              color: Colors.blueGrey,
              icon: Icon(Icons.zoom_out),
              tooltip: "Zoom out",
              onPressed: () => liveMapController.zoomOut()),
        ],
      ),
    );
  }

  void _onPressedAutoCenter() {
    print("MSG $messages");
    liveMapController.toggleAutoCenter();
    if (messages)
      Fluttertoast.showToast(
        msg: liveMapController.autoCenter
            ? "Auto center activated"
            : "Auto center deactivated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    onPressedAutoCenter();
    return null;
  }
}

class LiveMapSideBar extends StatefulWidget {
  LiveMapSideBar(
      {@required this.liveMapController,
      this.bottom,
      this.left,
      this.right,
      this.top,
      this.onPressedAutoCenter,
      this.messages});

  final LiveMapController liveMapController;
  final double top;
  final double right;
  final double bottom;
  final double left;
  final VoidCallback onPressedAutoCenter;
  final bool messages;

  @override
  _LiveMapSideBarState createState() => _LiveMapSideBarState(
        liveMapController: liveMapController,
        bottom: bottom,
        left: left,
        right: right,
        top: top,
        onPressedAutoCenter: onPressedAutoCenter,
        messages: messages,
      );
}
