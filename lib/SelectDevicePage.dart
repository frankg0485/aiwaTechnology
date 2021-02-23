import 'dart:typed_data';

import 'package:aiwa_technology/EQControl.dart';
import 'package:flutter/material.dart';
import 'package:aiwa_technology/Theme.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:aiwa_technology/Constants.dart';

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
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice device;
  BluetoothCharacteristic read;
  BluetoothCharacteristic write;


  _addDeviceTolist(final BluetoothDevice device) {
    print(device.name);
    if (device.name.contains("BLE")) {
      setState(() {
        this.device = device;
        flutterBlue.stopScan();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    flutterBlue.startScan();
  }

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
            Flexible(child: Container()),
            Padding(
              padding: EdgeInsets.only(
                  left: THEME.SCREEN_WIDTH / 4, right: THEME.SCREEN_WIDTH / 4),
              child: Image.asset(
                "assets/images/LogoImage.png",
              ),
            ),
            Flexible(child: Container()),
            Padding(
              padding: EdgeInsets.only(
                  left: THEME.SCREEN_WIDTH / 4, right: THEME.SCREEN_WIDTH / 4),
              child: Container(
                padding: EdgeInsets.all(THEME.CONTAINER_PADDING),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red[500],
                    width: 3,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: THEME.SCREEN_HEIGHT / 4,
                  ),
                  child: device == null ? Text("Scanning...") : Text(device.name),
              ),
              ),
            ),
            Flexible(child: Container()),
            FlatButton(
              padding: EdgeInsets.all(THEME.CONTAINER_PADDING * 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.black)),
              color: Colors.black,
              child: Text(
                "Connect",
                style: TextStyle(
                  fontFamily: THEME.BUTTON_FONT,
                  fontSize: 36 / 667 * THEME.SCREEN_HEIGHT,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                await device.connect();
                print("connected");
                List<BluetoothService> services = await device.discoverServices();
                services.forEach((service) async {
                  var characteristics = service.characteristics;
                  for(BluetoothCharacteristic c in characteristics) {
                    print(c.uuid);
                    if (c.uuid == Guid(BLE_READ_CHARACTERISTIC_UUID_STR)) {
                      read = c;
                    } else if (c.uuid == Guid(BLE_WRITE_CHARACTERISTIC_UUID_STR)) {
                      write = c;
                    } else {
                      print("ERROR: Unrecognized characteristic");
                    }
                   // List<int> value = await c.read();
                   // print(value);
                  }
                  // do something with service
                });
                print("-----------");
                var list = Uint8List(7);
                list.addAll([5, 90, 3, 0, -42, 12, 0]);
                write.write(list);
                read.value.listen((event) {
                  print("HELLLLLO");
                  print(event);
                });
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
