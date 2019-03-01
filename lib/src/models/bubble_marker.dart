import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_bubble/speech_bubble.dart';
import 'package:latlong/latlong.dart';

class BubbleMarker extends StatelessWidget {
  BubbleMarker(
      {@required this.name,
      @required this.point,
      this.isPoped = false,
      @required this.onTap,
      @required this.onDoubleTap});

  final String name;
  final LatLng point;
  final bool isPoped;
  final Function onTap;
  final Function onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        isPoped
            ? GestureDetector(
                child: SpeechBubble(
                  child: Text(
                    name,
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                ),
                onTap: () => onTap(context),
                onDoubleTap: () => onDoubleTap(context),
              )
            : Text(""),
        IconButton(
          icon: Icon(
            Icons.location_on,
            size: 30.0,
          ),
          onPressed: () {
            print("BUBBLE MARKER $name : $point");
            onTap(context);
            /*print("${liveMapController.namedMarkers}");
            for (var m in liveMapController.markers) {
              print("Marker : ${m.point}");
            }*/
          },
        ),
      ],
    );
  }
}
