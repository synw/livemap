import 'package:flutter/material.dart';
import 'home.dart';
import 'simple.dart';
import 'bottom_bar.dart';

final routes = {
  '/simple': (BuildContext context) => SimpleLiveMapPage(),
  '/bottom_bar': (BuildContext context) => LiveMapWithBottomBarMapPage(),
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
