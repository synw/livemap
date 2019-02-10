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
  StreamSubscription stateChangeSub;

  get _liveMapStatusIcon => _getStatusIcon();

  @override
  void initState() {
    stateChangeSub = liveMapController.stateChangeFeed.listen((stateChange) {
      if (stateChange.name == "positionStream") {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    stateChangeSub.cancel();
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
              icon: Icon(Icons.zoom_in),
              onPressed: () {
                liveMapController.zoomIn();
              }),
          IconButton(
              iconSize: 30.0,
              color: Colors.blueGrey,
              icon: Icon(Icons.zoom_out),
              onPressed: () {
                liveMapController.zoomOut();
              }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
          ),
          IconButton(
              iconSize: 30.0,
              color: Colors.blueGrey,
              icon: _liveMapStatusIcon,
              onPressed: () {
                liveMapController.togglePositionStream();
              }),
          IconButton(
            iconSize: 30.0,
            color: Colors.blueAccent,
            icon: Icon(Icons.menu),
            //onPressed: () => popMenu(context),
            onPressed: (popMenu != null) ? () => popMenu(context) : () {},
          ),
        ],
      ),
      color: Colors.white,
    );
  }

  Icon _getStatusIcon() {
    print("STATUS ${liveMapController.positionStreamEnabled}");
    Icon ic;
    liveMapController.positionStreamEnabled
        ? ic = Icon(Icons.gps_not_fixed)
        : ic = Icon(Icons.gps_off);
    return ic;
  }
}

class LiveMapBottomNavigationBar extends StatefulWidget {
  LiveMapBottomNavigationBar({@required this.liveMapController, this.popMenu});

  final LiveMapController liveMapController;
  final Function popMenu;

  @override
  _LiveMapBottomNavigationBarState createState() =>
      _LiveMapBottomNavigationBarState(
          liveMapController: liveMapController, popMenu: popMenu);
}
