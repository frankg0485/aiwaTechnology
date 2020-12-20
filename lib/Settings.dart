import 'package:aiwa_technology/EQControl.dart';
import 'package:flutter/material.dart';
import 'package:aiwa_technology/Theme.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    THEME.SCREEN_WIDTH = MediaQuery.of(context).size.width;
    THEME.SCREEN_HEIGHT = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Hello"),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text("Hello"),
      ),
    );
  }
}
