import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../controller.dart';
import 'buttons.dart';

class _LiveMapSideBarState extends State<LiveMapSideBar> {
  _LiveMapSideBarState({
    @required this.liveMapController,
    this.bottom,
    this.left,
    this.right,
    this.top,
    this.extraControls,
  }) : assert(liveMapController != null) {
    (top == null && bottom == null) ? top = 35.0 : top = top;
    (right == null && left == null) ? right = 20.0 : right = right;
  }

  final LiveMapController liveMapController;
  double top;
  double right;
  final double bottom;
  final double left;
  List<Widget> extraControls;

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
      MapCenterOnLiveMarker(liveMapController: liveMapController),
      MapToggleAutoCenter(liveMapController: liveMapController),
      MapTogglePositionStream(liveMapController: liveMapController),
      MapZoomIn(liveMapController: liveMapController),
      MapZoomOut(liveMapController: liveMapController),
    ];
    if (extraControls != null) sc.addAll(extraControls);
    return sc;
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

  /// Extra buttons to add to the sidebar
  final List<Widget> extraControls;

  @override
  _LiveMapSideBarState createState() => _LiveMapSideBarState(
        liveMapController: liveMapController,
        bottom: bottom,
        left: left,
        right: right,
        top: top,
        extraControls: extraControls,
      );
}
