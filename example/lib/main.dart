import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geopoint/geopoint.dart';
import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';

class LiveMapPage extends StatefulWidget {
  @override
  _LiveMapPageState createState() => _LiveMapPageState();
}

class _LiveMapPageState extends State<LiveMapPage> {
  static final MapController mapController = MapController();
  static final LiveMapController liveMapController =
      LiveMapController(mapController: mapController);
  static final Stream<Position> positionStream =
      PositionStream(timeInterval: 3).stream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LiveMap(
          positionStream: positionStream,
          mapController: mapController,
          liveMapController: liveMapController,
          mapOptions: MapOptions(
            center: LatLng(51.0, 0.0),
            zoom: 13.0,
          ),
          titleLayer: TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
        ),
        bottomNavigationBar: LiveMapBottomNavigationBar(
          liveMapController: liveMapController,
        ));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapjoe Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LiveMapPage(),
    );
  }
}
/*
class LiveMapPage extends StatelessWidget {
  
}*/

void main() => runApp(MyApp());
