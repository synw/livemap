import 'package:device/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

/// The default marker builder
Marker defaultLiveMarkerBuilder(Device device) {
  assert(device != null);
  assert(device.position != null);
  return Marker(
      anchorPos: AnchorPos.align(AnchorAlign.top),
      point: device.position.point,
      width: 80.0,
      height: 80.0,
      builder: (BuildContext c) =>
          Container(child: const Icon(Icons.directions, color: Colors.red)));
}
