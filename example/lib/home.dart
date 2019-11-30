import 'package:flutter/material.dart';

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightBlue,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                child: ButtonTheme(
                    minWidth: double.infinity, child: Text("Simple")),
                onPressed: () {
                  Navigator.of(context).pushNamed("/simple");
                },
              ),
              RaisedButton(
                child: ButtonTheme(
                    minWidth: double.infinity, child: Text("With bottom bar")),
                onPressed: () {
                  Navigator.of(context).pushNamed("/bottom_bar");
                },
              ),
              RaisedButton(
                  child: ButtonTheme(
                      minWidth: double.infinity, child: Text("Sidebar")),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/sidebar");
                  }),
              RaisedButton(
                  child: ButtonTheme(
                      minWidth: double.infinity,
                      child: Text("Auto rotation from bearing")),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/rotation");
                  }),
            ]));
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
