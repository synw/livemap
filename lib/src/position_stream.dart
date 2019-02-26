import 'package:geolocator/geolocator.dart';

Stream<Position> initPositionStream(
    {int timeInterval = 3000, int distanceFilter}) {
  Stream<Position> positionStream = Geolocator()
      .getPositionStream(LocationOptions(
          accuracy: LocationAccuracy.best,
          timeInterval: timeInterval,
          distanceFilter: distanceFilter))
      .asBroadcastStream();
  return positionStream;
}
