import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models.dart';

class PositionStreamState {
  PositionStreamState(
      {@required this.changeFeedController,
      @required this.positionStreamSubscription})
      : assert(changeFeedController != null);

  bool enabled = true;
  StreamController<LiveMapControllerStateChange> changeFeedController;

  StreamSubscription<Position> positionStreamSubscription;

  toggle() {
    enabled = !enabled;
    print("TOGGLE POSITION STREAM TO $enabled");
    if (!enabled) {
      print("=====> LIVE MAP DISABLED");
      positionStreamSubscription.pause();
      //getPos();
    } else {
      print("=====> LIVE MAP ENABLED");
      if (positionStreamSubscription.isPaused) {
        positionStreamSubscription.resume();
      }
    }
    LiveMapControllerStateChange cmd =
        LiveMapControllerStateChange(name: "positionStream", value: enabled);
    changeFeedController.sink.add(cmd);
  }
}
