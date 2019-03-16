import 'package:flutter/foundation.dart';

/// Desctiption of a state change
class LiveMapControllerStateChange {
  /// Name and value of the change
  LiveMapControllerStateChange(
      {@required this.name, @required this.value, this.from})
      : assert(name != null);

  /// Name of the change
  final String name;

  /// Value of the change
  final dynamic value;

  /// Where the change comes from
  final Function from;

  /// String representation
  @override
  String toString() {
    return "${this.name} ${this.value} from ${this.from}";
  }
}
