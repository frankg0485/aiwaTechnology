import 'package:flutter/material.dart';
import 'package:aiwa_technology/Theme.dart';

class FOTAPage extends StatefulWidget {
  FOTAPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _FOTAPageState createState() => _FOTAPageState();
}

class _FOTAPageState extends State<FOTAPage> {
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
            Text("Hello"),
          ],
        ),
      ),
    );
  }
}
