import 'package:flutter/material.dart';
import 'home.dart';
import 'simple.dart';
import 'bottom_bar.dart';
import 'custom_controls.dart';
import 'sidebar.dart';
import 'markers.dart';

final routes = {
  '/simple': (BuildContext context) => SimpleLiveMapPage(),
  '/bottom_bar': (BuildContext context) => LiveMapWithBottomBarMapPage(),
  '/custom_controls': (BuildContext context) => CustomControlsPage(),
  '/sidebar': (BuildContext context) => SideBarPage(),
  '/markers': (BuildContext context) => LivemapMarkersPage(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Livemap examples',
      routes: routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

void main() => runApp(MyApp());
