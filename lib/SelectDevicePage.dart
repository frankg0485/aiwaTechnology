import 'package:aiwa_technology/EQControl.dart';
import 'package:flutter/material.dart';
import 'package:aiwa_technology/Theme.dart';

class ConnectDevicePage extends StatefulWidget {
  ConnectDevicePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _ConnectDevicePageState createState() => _ConnectDevicePageState();
}

class _ConnectDevicePageState extends State<ConnectDevicePage> {
  @override
  Widget build(BuildContext context) {
    THEME.SCREEN_WIDTH = MediaQuery.of(context).size.width;
    THEME.SCREEN_HEIGHT = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(child: Container()),
            Padding(
              padding: EdgeInsets.only(
                  left: THEME.SCREEN_WIDTH / 4, right: THEME.SCREEN_WIDTH / 4),
              child: Image.asset(
                "assets/images/LogoImage.png",
              ),
            ),
            Flexible(child: Container()),
            Container(
              padding: EdgeInsets.all(THEME.CONTAINER_PADDING),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red[500],
                  width: 3,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                "No Devices Found",
                style: TextStyle(
                  fontFamily: THEME.NORMAL_FONT,
                  fontSize: 24 / 667 * THEME.SCREEN_HEIGHT,
                  color: Colors.black,
                ),
              ),
            ),
            Flexible(child: Container()),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.black)
              ),
              color: Colors.black,
              child: Text(
                "Connect",
                style: TextStyle(
                  fontFamily: THEME.BUTTON_FONT,
                  fontSize: 36 / 667 * THEME.SCREEN_HEIGHT,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EQControlPage()),
                );
              },
            ),
            Flexible(child: Container()),
          ],
        ),
      ),
    );
  }
}
