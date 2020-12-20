import 'package:aiwa_technology/Settings.dart';
import 'package:flutter/material.dart';
import 'package:aiwa_technology/Theme.dart';
import 'package:aiwa_technology/Theme.dart';

class EQControlPage extends StatefulWidget {
  EQControlPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _EQControlPageState createState() => _EQControlPageState();
}

class _EQControlPageState extends State<EQControlPage> {
  var eqSliderValues = [0.5, 0.8, 0.0, 0.3, 0.2];
  var deviceName = "Aiwa Prodigy Air Max";
  var batteryLevel = 79;

  @override
  Widget build(BuildContext context) {
    THEME.SCREEN_WIDTH = MediaQuery.of(context).size.width;
    THEME.SCREEN_HEIGHT = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(THEME.CONTAINER_PADDING),
                decoration: BoxDecoration(
                  color: THEME.AIWA_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("Aiwa Prodigy Air Max",
                    style: TextStyle(
                      fontFamily: THEME.NORMAL_FONT,
                      fontSize: 18 / 667 * THEME.SCREEN_HEIGHT,
                      color: Colors.white,
                    )),
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: THEME.CONTAINER_PADDING * 2),
                    child: Image.asset(
                      "assets/images/BatteryIcon.png",
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(THEME.CONTAINER_PADDING),
                    decoration: BoxDecoration(
                      color: THEME.AIWA_COLOR,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      batteryLevel.toString() + "%",
                      style: TextStyle(
                        fontFamily: THEME.NORMAL_FONT,
                        fontSize: 18 / 667 * THEME.SCREEN_HEIGHT,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: eqSliders(),
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Low",
                    style: TextStyle(
                      fontFamily: THEME.NORMAL_FONT,
                      fontSize: 18 / 667 * THEME.SCREEN_HEIGHT,
                      color: Colors.black,
                    ),
                  ),
                  Container(),
                  Text(
                    "Mid",
                    style: TextStyle(
                      fontFamily: THEME.NORMAL_FONT,
                      fontSize: 18 / 667 * THEME.SCREEN_HEIGHT,
                      color: Colors.black,
                    ),
                  ),
                  Container(),
                  Text(
                    "High",
                    style: TextStyle(
                      fontFamily: THEME.NORMAL_FONT,
                      fontSize: 18 / 667 * THEME.SCREEN_HEIGHT,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
                child: Icon(Icons.settings),
                color: Colors.transparent,
                shape: CircleBorder(
                  side: BorderSide(
                    width: 3,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> eqSliders() {
    var sliders = List<Widget>();
    for (int i = 0; i < eqSliderValues.length; i++) {
      sliders.add(rotatedSlider(i));
    }
    return sliders;
  }

  RotatedBox rotatedSlider(index) {
    return RotatedBox(
      quarterTurns: 3,
      child: Slider(
        activeColor: THEME.AIWA_COLOR,
        value: eqSliderValues[index],
        onChanged: (newValue) {
          setState(() {
            eqSliderValues[index] = newValue;
          });
        },
      ),
    );
  }
}
