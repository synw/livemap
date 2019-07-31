import 'package:geolocator/geolocator.dart';

/// Initialize the position stream
Stream<Position> initPositionStream(
    {int timeInterval = 3000, int distanceFilter}) {
  var geolocator = Geolocator();
  LocationOptions options;
  if (distanceFilter == null) {
    options = LocationOptions(
        accuracy: LocationAccuracy.best, timeInterval: timeInterval);
  } else {
    options = LocationOptions(
        accuracy: LocationAccuracy.best, distanceFilter: distanceFilter);
  }
  Stream<Position> positionStream =
      geolocator.getPositionStream(options).asBroadcastStream();
  return positionStream;
}
