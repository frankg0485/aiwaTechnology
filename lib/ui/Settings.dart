import 'package:aiwa_technology/ui/FOTAPage.dart';
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
  var versionString = "1.3.1.2";

  @override
  Widget build(BuildContext context) {
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
          "Settings",
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
            FlatButton(
              padding: EdgeInsets.all(THEME.CONTAINER_PADDING * 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.black),
              ),
              color: Colors.black,
              child: Text(
                "Firmware Update",
                style: TextStyle(
                  fontFamily: THEME.BUTTON_FONT,
                  fontSize: 36 / 667 * THEME.SCREEN_HEIGHT,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FOTAPage(versionString: versionString)),
                );
              },
            ),
            FlatButton(
              padding: EdgeInsets.all(THEME.CONTAINER_PADDING * 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.black),
              ),
              color: Colors.black,
              child: Text(
                "Help",
                style: TextStyle(
                  fontFamily: THEME.BUTTON_FONT,
                  fontSize: 36 / 667 * THEME.SCREEN_HEIGHT,
                  color: Colors.white,
                ),
              ),
              onPressed: () {},
            ),
            FlatButton(
              padding: EdgeInsets.all(THEME.CONTAINER_PADDING * 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.black),
              ),
              color: Colors.black,
              child: Text(
                "Submit Feedback",
                style: TextStyle(
                  fontFamily: THEME.BUTTON_FONT,
                  fontSize: 36 / 667 * THEME.SCREEN_HEIGHT,
                  color: Colors.white,
                ),
              ),
              onPressed: () {},
            ),
            Container(
              padding: EdgeInsets.only(
                left: THEME.CONTAINER_PADDING * 2,
                right: THEME.CONTAINER_PADDING * 2,
                top: THEME.CONTAINER_PADDING,
                bottom: THEME.CONTAINER_PADDING,
              ),
              decoration: BoxDecoration(
                color: THEME.AIWA_COLOR,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                versionString,
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
    );
  }
}
