import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../controller.dart';

class _LiveMapState extends State<LiveMap> {
  _LiveMapState(
      {@required this.mapController,
      @required this.liveMapController,
      @required this.titleLayer,
      @required this.mapOptions,
      this.liveMap,
      this.markers,
      this.liveMarker})
      : assert(mapController != null) {
    markers = markers ?? <Marker>[];
    liveMap = liveMap ?? false;
    liveMarker = liveMarker ?? buildLivemarker();
  }

  final MapController mapController;
  final LiveMapController liveMapController;
  MapOptions mapOptions;
  TileLayerOptions titleLayer;
  List<Marker> markers;
  Marker liveMarker;
  bool liveMap;
  static num distanceFilter = 0;
  static int timeInterval = 3;

  LocationOptions locationOptions;
  Stream<Position> positionStream;
  StreamSubscription<Position> _positionStreamSubscription;

  @override
  void initState() {
    // init controller state
    liveMapController.setPositionStreamEnabled = liveMap;
    liveMapController.setCenter = mapOptions.center;
    liveMapController.setZoom = mapOptions.zoom;
    // init location stream
    (distanceFilter > 0)
        ? locationOptions = LocationOptions(
            accuracy: LocationAccuracy.best, distanceFilter: distanceFilter)
        : locationOptions = LocationOptions(
            accuracy: LocationAccuracy.best,
            timeInterval: (timeInterval * 1000));
    positionStream = Geolocator().getPositionStream(locationOptions);
    // set initial markers
    /*if (markers.length > 0) {
      if (liveMap) {
        markers.add(liveMarker);
      }
      liveMapController.updateMarkers(markers);
    }*/

    // set position stream callback
    mapController.onReady.then((_) {
      print("MAP IS READY");
    });
    _positionStreamSubscription = positionStream.listen((Position position) {
      print("POS $position");
      liveMapController.centerOnPosition(position);
      buildMarkers();
    });
    updatePositionStreamState();
    // set commands channel stream callback
    liveMapController.commands.listen((cmd) {
      setState(() {
        dispatchCommand(cmd);
      });
      //});
    });
    super.initState();
  }

  @override
  void dispose() {
    liveMapController.dispose();
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: mapOptions,
      layers: [
        titleLayer,
        MarkerLayerOptions(
          markers: markers,
        ),
      ],
    );
  }

  dispatchCommand(LiveMapControllerCommand cmd) {
    print("COMMAND RECEIVED ${cmd.toString()}");
    if (cmd.name == "setPositionStream") {
      liveMap = cmd.value;
      updatePositionStreamState();
    }
  }

  buildMarkers() {
    if (markers.contains(liveMarker)) {
      markers.remove(liveMarker);
    }
    liveMarker = buildLivemarker();
    markers.add(liveMarker);
    liveMapController.updateMarkers(markers);
  }

  updatePositionStreamState() async {
    if (liveMap == false) {
      print("=====> LIVE MAP DISABLED");
      _positionStreamSubscription.pause();
      //getPos();
    } else {
      print("=====> LIVE MAP ENABLED");
      if (_positionStreamSubscription.isPaused) {
        _positionStreamSubscription.resume();
      }
    }
  }

  Marker buildLivemarker({LatLng position}) {
    num lat = mapController.ready
        ? mapController.center.latitude
        : mapOptions.center.latitude;
    num lon = mapController.ready
        ? mapController.center.longitude
        : mapOptions.center.longitude;
    LatLng _position = position ?? LatLng(lat, lon);
    return Marker(
      width: 80.0,
      height: 80.0,
      point: _position,
      builder: (ctx) => Container(
            child: Icon(
              Icons.directions,
              color: Colors.red,
            ),
          ),
    );
  }
}

class LiveMap extends StatefulWidget {
  LiveMap({
    @required this.mapController,
    @required this.liveMapController,
    this.titleLayer,
    this.mapOptions,
    this.markers,
  });

  final MapOptions mapOptions;
  final TileLayerOptions titleLayer;
  final MapController mapController;
  final List<Marker> markers;
  final LiveMapController liveMapController;

  @override
  _LiveMapState createState() => _LiveMapState(
        mapOptions: mapOptions,
        titleLayer: titleLayer,
        mapController: mapController,
        markers: markers,
        liveMapController: liveMapController,
      );
}
