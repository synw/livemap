import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../map_opions.dart';
import '../controller.dart';
import '../models.dart';

class _LiveMapState extends State<LiveMap> {
  _LiveMapState(
      {@required this.mapController,
      @required this.liveMapController,
      @required this.titleLayer,
      @required this.liveMapOptions,
      @required this.positionStream,
      this.enablePositionStream,
      this.markers,
      this.liveMarker})
      : assert(mapController != null) {
    markers = markers ?? <Marker>[];
    enablePositionStream = enablePositionStream ?? true;
    liveMarker = liveMarker ?? buildLivemarker();
  }

  final MapController mapController;
  final LiveMapController liveMapController;
  final Stream<Position> positionStream;
  LiveMapOptions liveMapOptions;
  TileLayerOptions titleLayer;
  List<Marker> markers;
  Marker liveMarker;
  bool enablePositionStream;
  static num distanceFilter = 0;
  static int timeInterval = 3;

  StreamSubscription<Position> _positionStreamSubscription;
  StreamSubscription<LiveMapControllerStateChange> _changefeed;

  @override
  void initState() {
    // init controller state
    liveMapController.positionStream.enabled = enablePositionStream;
    liveMapController.center = liveMapOptions.center;
    liveMapController.zoom = liveMapOptions.zoom;

    mapController.onReady.then((_) {
      print("MAP IS READY");
    });

    // set position stream callback
    _positionStreamSubscription = positionStream.listen((Position position) {
      print("POS $position");
      liveMapController.centerOnPosition(position);
      buildMarkers();
    });
    updatePositionStreamState();

    // set commands channel stream callback
    _changefeed = liveMapController.changeFeed.listen((cmd) {
      setState(() {
        dispatchCommand(cmd);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    print("DISPOSE LIVEMAP");
    _positionStreamSubscription.cancel();
    _changefeed.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: liveMapOptions.mapOptions,
      layers: [
        titleLayer,
        MarkerLayerOptions(
          markers: markers,
        ),
      ],
    );
  }

  dispatchCommand(LiveMapControllerStateChange ch) {
    print("STATE CHANGE RECEIVED ${ch.toString()}");
    if (ch.name == "positionStream") {
      enablePositionStream = ch.value;
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
    if (!enablePositionStream) {
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
        : liveMapOptions.center.latitude;
    num lon = mapController.ready
        ? mapController.center.longitude
        : liveMapOptions.center.longitude;
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
    @required this.positionStream,
    this.titleLayer,
    this.liveMapOptions,
    this.markers,
    this.enablePositionStream,
  });

  final LiveMapOptions liveMapOptions;
  final TileLayerOptions titleLayer;
  final Stream<Position> positionStream;
  final MapController mapController;
  final List<Marker> markers;
  final LiveMapController liveMapController;
  final bool enablePositionStream;

  @override
  _LiveMapState createState() => _LiveMapState(
      liveMapOptions: liveMapOptions,
      titleLayer: titleLayer,
      mapController: mapController,
      positionStream: positionStream,
      markers: markers,
      liveMapController: liveMapController,
      enablePositionStream: enablePositionStream);
}
