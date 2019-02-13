import 'package:flutter/foundation.dart';

class LiveMapControllerStateChange {
  LiveMapControllerStateChange({@required this.name, @required this.value})
      : assert(name != null),
        assert(value != null);

  String name;
  dynamic value;

  @override
  String toString() {
    return "${this.name} ${this.value}";
  }
}
