import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../controller.dart';

class _LiveMapBottomNavigationBarState
    extends State<LiveMapBottomNavigationBar> {
  _LiveMapBottomNavigationBarState(
      {@required this.liveMapController, this.popMenu});

  final LiveMapController liveMapController;
  final Function popMenu;
  StreamSubscription _stateChangeSubscription;

  Icon get _liveMapStatusIcon => _getliveMapStatusIcon();
  Icon get _liveMapAutoCenterIcon => _getLiveMapAutoCenterIcon();

  @override
  void initState() {
    _stateChangeSubscription =
        liveMapController.changeFeed.listen((stateChange) {
      if (stateChange.name == "positionStream") {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _stateChangeSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              iconSize: 30.0,
              color: Colors.blueGrey,
              icon: const Icon(Icons.zoom_in),
              onPressed: () {
                liveMapController.zoomIn();
              }),
          IconButton(
              iconSize: 30.0,
              color: Colors.blueGrey,
              icon: const Icon(Icons.zoom_out),
              onPressed: () {
                liveMapController.zoomOut();
              }),
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
          ),
          IconButton(
              iconSize: 30.0,
              color: Colors.blueGrey,
              icon: _liveMapStatusIcon,
              onPressed: () {
                liveMapController.togglePositionStreamSubscription();
              }),
          IconButton(
            iconSize: 30.0,
            color: Colors.blueGrey,
            icon: (popMenu == null)
                ? _liveMapAutoCenterIcon
                : const Icon(Icons.menu),
            onPressed: () {
              (popMenu == null)
                  ? liveMapController.toggleAutoCenter()
                  : popMenu(context);
            },
          ),
        ],
      ),
      color: Colors.white,
    );
  }

  Icon _getliveMapStatusIcon() {
    Icon ic;
    liveMapController.positionStreamEnabled
        ? ic = const Icon(Icons.gps_not_fixed)
        : ic = const Icon(Icons.gps_off);
    return ic;
  }

  Icon _getLiveMapAutoCenterIcon() {
    Icon ic;
    (liveMapController.autoCenter != null)
        ? ic = const Icon(Icons.center_focus_strong)
        : ic = const Icon(Icons.center_focus_weak);
    return ic;
  }
}

/// The bottom navbar
class LiveMapBottomNavigationBar extends StatefulWidget {
  /// Provide a [LiveMapController]
  LiveMapBottomNavigationBar({@required this.liveMapController, this.popMenu});

  /// The [LiveMapController]
  final LiveMapController liveMapController;

  /// An optional menu action
  final Function popMenu;

  @override
  _LiveMapBottomNavigationBarState createState() =>
      _LiveMapBottomNavigationBarState(
          liveMapController: liveMapController, popMenu: popMenu);
}
