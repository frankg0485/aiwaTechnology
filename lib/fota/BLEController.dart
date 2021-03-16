import 'dart:typed_data';
//PLEASE CHANGE
import 'package:aiwa_technology/fota/AiwaLink.dart' as link;

import 'package:aiwa_technology/fota/AiwaLink.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

BluetoothCharacteristic readC;
BluetoothCharacteristic writeC;

class BleController {
  static final BLE_READ_CHARACTERISTIC_UUID_STR =
      "43484152-2DAB-3141-6972-6F6861424C45";
  static final BLE_WRITE_CHARACTERISTIC_UUID_STR =
      "43484152-2DAB-3241-6972-6F6861424C45";

  AiwaLink mAiwaLink;

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice device;

  ValueNotifier deviceAdded = ValueNotifier(false);

  BleController(AiwaLink aiwaLink) {
    mAiwaLink = aiwaLink;
  }

  void _addDeviceToList(BluetoothDevice d) {
    print(d.name);
    //Only add Aiwa BLE device then stop scanning
    if (d.name.contains("BLE")) {
      device = d;
      deviceAdded.value = true;
      flutterBlue.stopScan();
    }
  }

  //SCAN SHOULD BE HERE
  void _scanDevices() {
    flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceToList(device);
      }
    });
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceToList(result.device);
      }
    });
    flutterBlue.startScan();
  }

  void connectToDevice() async {
    _scanDevices();

    deviceAdded.addListener(() async {
      await device.connect();
      print("BLE device connected");
      await scanCharacteristics();
      print("characteristics found");
    });
  }

  Future<bool> scanCharacteristics() async {
    if (device == null) {
      print("ERROR - NO DEVICE, CAN'T SCAN FOR SERVICES/CHARACTERISTICS");
      return false;
    }

    /*
    try {
      device.requestMtu(273);
    } catch (error) {
      print("ERROR: " + error);
    }

    print(await device.mtu.first);*/
    //No check against device not connected

    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) async {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        print(c.uuid);
        if (c.uuid == Guid(BLE_READ_CHARACTERISTIC_UUID_STR)) {
          readC = c;
        } else if (c.uuid == Guid(BLE_WRITE_CHARACTERISTIC_UUID_STR)) {
          writeC = c;
        } else {
          print("ERROR -  Unrecognized characteristic");
        }
      }
      listenReadCharacteristic();
      return true;
    });

    return false;
  }

  void listenReadCharacteristic() {
    readC.value.listen((event) async {
      /*final test = await readC.read();
      print(test);*/
      print("BLE Controller: characteristic read");
      Int8List packet = Int8List.fromList(event);

      //Log.d(TAG, "onCharacteristicChanged :  " + Converter.byte2HexStr(packet));

      if (!packet.isEmpty) {
        mAiwaLink.handlePhysicalPacket(packet);
      } else {
        print("read packet is empty");
      }
      print(event);
    });
    readC.setNotifyValue(true);
  }

  Future<bool> write(Int8List cmd) async {
    print(cmd);
    print("BLE Controller: write newCmd to characteristic");
    return await writeC.write(cmd);
  }
}
