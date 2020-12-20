import 'package:flutter/material.dart';
import 'package:aiwa_technology/Theme.dart';
import 'dart:async';

class FOTAPage extends StatefulWidget {
  FOTAPage({Key key, this.versionString}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  var versionString;

  @override
  _FOTAPageState createState() => _FOTAPageState();
}

class _FOTAPageState extends State<FOTAPage> {
  var currentVersionStr = "";
  var deviceName = "Aiwa Prodigy Air Max";
  var allFWVersions = ["1.1.1.1", "1.1.2.4", "1.2.1.3", "1.3.1.2", "1.5.3.3"];
  var selectedVersion = "";

  _FOTAPageState() {
    selectedVersion = allFWVersions[2];
  }

  @override
  Widget build(BuildContext context) {
    currentVersionStr = widget.versionString;
    THEME.SCREEN_WIDTH = MediaQuery.of(context).size.width;
    THEME.SCREEN_HEIGHT = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        toolbarHeight: THEME.SCREEN_HEIGHT / 6,
        title: Text(
          "Update",
          style: TextStyle(
            fontFamily: THEME.NORMAL_FONT,
            fontSize: 48 / 667 * THEME.SCREEN_HEIGHT,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(THEME.CONTAINER_PADDING),
                decoration: BoxDecoration(
                  color: THEME.AIWA_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  deviceName,
                  style: TextStyle(
                    fontFamily: THEME.NORMAL_FONT,
                    fontSize: 18 / 667 * THEME.SCREEN_HEIGHT,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(THEME.CONTAINER_PADDING),
                decoration: BoxDecoration(
                  color: THEME.AIWA_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  currentVersionStr,
                  style: TextStyle(
                    fontFamily: THEME.NORMAL_FONT,
                    fontSize: 18 / 667 * THEME.SCREEN_HEIGHT,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(),
            DropdownButton<String>(
              value: selectedVersion,
              items: allFWVersions.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newVersion) {
                setState(() {
                  selectedVersion = newVersion;
                });
              },
            ),
            //Flexible(flex: 2, child: Container()),
            Flexible(
              flex: 1,
              child: FlatButton(
                padding: EdgeInsets.only(
                  left: THEME.CONTAINER_PADDING * 2,
                  right: THEME.CONTAINER_PADDING * 2,
                  top: THEME.CONTAINER_PADDING,
                  bottom: THEME.CONTAINER_PADDING,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.black),
                ),
                color: Colors.black,
                child: Text(
                  "Update",
                  style: TextStyle(
                    fontFamily: THEME.BUTTON_FONT,
                    fontSize: 24 / 667 * THEME.SCREEN_HEIGHT,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  _ProgressIndicatorDemoState.beginAnimation();
                },
              ),
            ),
            ProgressIndicatorDemo(),
          ],
        ),
      ),
    );
  }
}

class ProgressIndicatorDemo extends StatefulWidget {
  @override
  _ProgressIndicatorDemoState createState() =>
      new _ProgressIndicatorDemoState();
}

class _ProgressIndicatorDemoState extends State<ProgressIndicatorDemo>
    with SingleTickerProviderStateMixin {
  static AnimationController controller;
  Animation<double> animation;

  static void beginAnimation() {
    controller.forward();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value == 1.0) {
            controller.stop();
          }
        });
      });
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.isCompleted) { return Text("Firmware Update Complete"); }
    else if (!controller.isAnimating) { return Container(width: 0, height: 0); }
    return new Center(
        child: new Container(
      child: LinearProgressIndicator(
        value: animation.value,
      ),
    ));
  }
}
