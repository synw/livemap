import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_bubble/speech_bubble.dart';
import 'package:geopoint/geopoint.dart';
import '../controller.dart';

typedef void GeoMarkerAction(BuildContext context, GeoPoint geoPoint);

class _GeoPointMarkerState extends State<GeoPointMarker> {
  _GeoPointMarkerState(
      {@required this.geoPoint,
      @required this.liveMapController,
      this.onTap,
      this.onDoubleTap})
      : assert(geoPoint != null) {
    onTap = onTap ?? (_, __) => null;
    onDoubleTap = onDoubleTap ??
        (_, __) => liveMapController.removeMarker(name: geoPoint.name);
  }

  final GeoPoint geoPoint;
  final LiveMapController liveMapController;
  GeoMarkerAction onTap;
  GeoMarkerAction onDoubleTap;

  bool isPoped = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        isPoped
            ? GestureDetector(
                child: SpeechBubble(
                  child: Text(
                    geoPoint.name,
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                ),
                onTap: () => onTap(context, geoPoint),
              )
            : Text(""),
        GestureDetector(
          child: Icon(
            Icons.location_on,
            size: 30.0,
          ),
          onTap: () => setState(() {
                isPoped = !isPoped;
              }),
          onDoubleTap: () => onDoubleTap,
        ),
      ],
    );
  }
}

class GeoPointMarker extends StatefulWidget {
  GeoPointMarker(
      {Key key,
      @required this.geoPoint,
      @required this.liveMapController,
      this.onTap,
      this.onDoubleTap});

  final GeoPoint geoPoint;
  final LiveMapController liveMapController;
  final GeoMarkerAction onTap;
  final GeoMarkerAction onDoubleTap;

  @override
  _GeoPointMarkerState createState() => _GeoPointMarkerState(
      geoPoint: geoPoint,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      liveMapController: liveMapController);
}
