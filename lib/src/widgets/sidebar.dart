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
    this.extraControls,
  }) : assert(liveMapController != null) {
    onPressedAutoCenter = onPressedAutoCenter ?? () => null;
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
  List<Widget> extraControls;

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
        children: buildSideControls(),
      ),
    );
  }

  List<Widget> buildSideControls() {
    var sc = <Widget>[
      IconButton(
        iconSize: 30.0,
        color: Colors.blueGrey,
        icon: const Icon(Icons.crop_free),
        tooltip: "Center",
        onPressed: () => liveMapController.centerOnLiveMarker(),
      ),
      IconButton(
        iconSize: 30.0,
        color: Colors.blueGrey,
        icon: const Icon(Icons.center_focus_weak),
        tooltip: "Toggle autocenter",
        onPressed: _onPressedAutoCenter,
      ),
      IconButton(
        iconSize: 30.0,
        color: Colors.blueGrey,
        icon: _positionStreamEnabled
            ? const Icon(Icons.gps_not_fixed)
            : const Icon(Icons.gps_off),
        tooltip: "Toggle live position updates",
        onPressed: () {
          liveMapController.togglePositionStreamSubscription();
          if (messages) {
            Fluttertoast.showToast(
              msg: (liveMapController.positionStreamEnabled)
                  ? "Position updates enabled"
                  : "Position updates disabled",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        },
      ),
      IconButton(
          iconSize: 30.0,
          color: Colors.blueGrey,
          icon: const Icon(Icons.zoom_in),
          tooltip: "Zoom in",
          onPressed: () => liveMapController.zoomIn()),
      IconButton(
          iconSize: 30.0,
          color: Colors.blueGrey,
          icon: const Icon(Icons.zoom_out),
          tooltip: "Zoom out",
          onPressed: () => liveMapController.zoomOut()),
    ];
    if (extraControls != null) sc.addAll(extraControls);
    return sc;
  }

  void _onPressedAutoCenter() {
    liveMapController.toggleAutoCenter();
    if (messages) {
      Fluttertoast.showToast(
        msg: liveMapController.autoCenter
            ? "Auto center activated"
            : "Auto center deactivated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
    onPressedAutoCenter();
    return null;
  }
}

/// A sidebar for the livemap
class LiveMapSideBar extends StatefulWidget {
  /// Provide a [LiveMapController]
  LiveMapSideBar(
      {@required this.liveMapController,
      this.bottom,
      this.left,
      this.right,
      this.top,
      this.onPressedAutoCenter,
      this.messages,
      this.extraControls});

  /// The  [LiveMapController]
  final LiveMapController liveMapController;

  /// The position from top
  final double top;

  /// The position from right
  final double right;

  /// The position from bottom
  final double bottom;

  /// The position from left
  final double left;

  /// The autocenter callback
  final VoidCallback onPressedAutoCenter;

  /// Show messages to user after actions
  final bool messages;

  /// Extra buttons to add to the sidebar
  final List<Widget> extraControls;

  @override
  _LiveMapSideBarState createState() => _LiveMapSideBarState(
        liveMapController: liveMapController,
        bottom: bottom,
        left: left,
        right: right,
        top: top,
        onPressedAutoCenter: onPressedAutoCenter,
        messages: messages,
        extraControls: extraControls,
      );
}
