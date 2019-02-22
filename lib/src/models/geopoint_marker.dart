import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_bubble/speech_bubble.dart';
import 'package:geopoint/geopoint.dart';

typedef void GeoMarkerOnTap(BuildContext context, GeoPoint geoPoint);

class _GeoPointMarkerState extends State<GeoPointMarker> {
  _GeoPointMarkerState({@required this.geoPoint, this.onTap})
      : assert(geoPoint != null) {
    onTap = onTap ?? (_, __) => null;
  }

  final GeoPoint geoPoint;
  GeoMarkerOnTap onTap;

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
        IconButton(
          iconSize: 30.0,
          icon: Icon(Icons.location_on),
          onPressed: () => setState(() {
                isPoped = !isPoped;
              }),
        )
      ],
    );
  }
}

class GeoPointMarker extends StatefulWidget {
  GeoPointMarker({@required this.geoPoint, this.onTap});

  final GeoPoint geoPoint;
  final GeoMarkerOnTap onTap;

  @override
  _GeoPointMarkerState createState() =>
      _GeoPointMarkerState(geoPoint: geoPoint, onTap: onTap);
}
