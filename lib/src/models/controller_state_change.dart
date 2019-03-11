import 'package:flutter/foundation.dart';

class LiveMapControllerStateChange {
  LiveMapControllerStateChange(
      {@required this.name, @required this.value, this.from})
      : assert(name != null);

  String name;
  dynamic value;
  Function from;

  @override
  String toString() {
    return "${this.name} ${this.value} from ${this.from}";
  }
}
