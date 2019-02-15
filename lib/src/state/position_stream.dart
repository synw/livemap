import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models.dart';

class PositionStreamState {
  PositionStreamState({@required this.changeFeedController})
      : assert(changeFeedController != null);

  bool _enabled = true;
  StreamController<LiveMapControllerStateChange> changeFeedController;

  get enabled => _enabled;
  set enabled(e) => _enabled = e;

  toggle() {
    _enabled = !_enabled;
    print("TOGGLE POSITION STREAM TO $_enabled");
    LiveMapControllerStateChange cmd =
        LiveMapControllerStateChange(name: "positionStream", value: _enabled);
    changeFeedController.sink.add(cmd);
  }
}
