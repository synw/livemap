import 'package:flutter/material.dart';

import 'bottom_bar.dart';
import 'home.dart';
import 'rotation.dart';
import 'sidebar.dart';
import 'simple.dart';

final routes = {
  '/simple': (BuildContext context) => SimpleLiveMapPage(),
  '/bottom_bar': (BuildContext context) => LiveMapWithBottomBarMapPage(),
  '/sidebar': (BuildContext context) => SideBarPage(),
  '/rotation': (BuildContext context) => RotationPage(),
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
