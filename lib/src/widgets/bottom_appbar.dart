import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../controller.dart';

class LiveMapBottomNavigationBar extends StatelessWidget {
  LiveMapBottomNavigationBar({@required this.liveMapController});

  final LiveMapController liveMapController;

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
              /*icon: liveMapController.positionStreamEnabled
                  ? Icon(Icons.gps_not_fixed)
                  : Icon(Icons.gps_off),*/
              icon: Icon(Icons.gps_off),
              onPressed: () {
                liveMapController.togglePositionStream();
              }),
          IconButton(
            iconSize: 30.0,
            color: Colors.blueAccent,
            icon: Icon(Icons.menu),
            //onPressed: () => popMenu(context),
            onPressed: () => print("P"),
          ),
        ],
      ),
      color: Colors.white,
    );
  }
}
