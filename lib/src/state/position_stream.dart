import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models.dart';

class PositionStreamState {
  PositionStreamState({@required this.changeFeedController})
      : assert(changeFeedController != null);

  bool enabled = true;
  StreamController<LiveMapControllerStateChange> changeFeedController;

  toggle() {
    enabled = !enabled;
    print("TOGGLE POSITION STREAM TO $enabled");
    LiveMapControllerStateChange cmd =
        LiveMapControllerStateChange(name: "positionStream", value: enabled);
    changeFeedController.sink.add(cmd);
  }
}
