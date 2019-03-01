/*import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_bubble/speech_bubble.dart';
import 'package:geopoint/geopoint.dart';
import '../controller.dart';


typedef void GeoMarkerAction(BuildContext context, GeoPoint geoPoint);

class _GeoPointMarkerState extends State<GeoPointMarker> {
  _GeoPointMarkerState(
      {this.key,
      @required this.geoPoint,
      @required this.liveMapController,
      this.isPoped = false,
      this.onTap,
      this.onDoubleTap})
      : assert(geoPoint != null) {
    _isPoped = isPoped ?? false;
    onTap = onTap ?? (_, __) => null;
    onDoubleTap = onDoubleTap ??
        (_, __) => liveMapController.removeMarker(name: geoPoint.name);
  }

  final Key key;
  final GeoPoint geoPoint;
  final LiveMapController liveMapController;
  final isPoped;
  GeoMarkerAction onTap;
  GeoMarkerAction onDoubleTap;

  bool _isPoped;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _isPoped
            ? GestureDetector(
                child: SpeechBubble(
                  key: key,
                  child: Text(
                    geoPoint.name,
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                ),
                onTap: () => onTap(context, geoPoint),
              )
            : Text(""),
        IconButton(
          icon: Icon(
            Icons.location_on,
            size: 30.0,
          ),
          onPressed: () {
            print("$geoPoint");
            print("${liveMapController.namedMarkers}");
            for (var m in liveMapController.markers) {
              print("Marker : ${m.point}");
            }
          },
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
      this.isPoped,
      this.onTap,
      this.onDoubleTap})
      : super(key: key);

  final GeoPoint geoPoint;
  final LiveMapController liveMapController;
  final bool isPoped;
  final GeoMarkerAction onTap;
  final GeoMarkerAction onDoubleTap;

  @override
  _GeoPointMarkerState createState() => _GeoPointMarkerState(
      key: key,
      geoPoint: geoPoint,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      liveMapController: liveMapController,
      isPoped: isPoped);
}*/
