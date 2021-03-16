import 'dart:typed_data';

import 'package:aiwa_technology/fota/BLEController.dart';
import 'package:aiwa_technology/transport/RacePacketByH4Dispatcher.dart';


class AiwaLink {
  BleController controller;
  RacePacketByH4Dispatcher mRacePacketByH4Dispatcher;

  AiwaLink() {
    controller = BleController(this);
    mRacePacketByH4Dispatcher = RacePacketByH4Dispatcher();
  }

  void connect() async {
    await controller.connectToDevice();
  }

  Future<bool> sendCommand(Int8List cmd) {
    print("AiwaLink: send command");
    //logToFile(TAG, "Tx packet: " + Converter.byte2HexStr(cmd));

    //if (cmd[0] == RacePacketByH4Dispatcher.RACE_BY_H4_START && cmd[1] == RaceType.CMD_NEED_RESP) {
    // start timeout timer
    //logToFile(TAG, "Cmd needs Resp start count down");

    /*if (mTimerForCmdResp != null) {
  mTimerForCmdResp.cancel();
  }

  mTimerForCmdResp = new Timer();
  mTimerForCmdResp.schedule(new CmdTimeoutTask(), mTimeoutRaceCmdNotResp);
  }*/

    return controller.write(cmd);
  }

  void handlePhysicalPacket(Int8List packet) {
    print("AiwaLink: handle physical packet");
    //logToFile(TAG, "handlePhysicalPacket Rx packet: " + Converter.byte2HexStr(packet));

    //logRawToBin(packet);

    // check for RACE_BY_H4
    if (RacePacketByH4Dispatcher.isRaceByH4Collected(packet)) {
      print("AiwaLink: packet is race by H4");
      // stop timeout timer

      /*if (mTimerForCmdResp != null) {
  mTimerForCmdResp.cancel();
  }*/

      mRacePacketByH4Dispatcher.parseSend(packet);

      /*if (RacePacketByH4Dispatcher.isRaceResponse(packet)) {
  checkQueuedActions();
  }*/
    } else {
      print("AiwaLink: packet is not race by H4");
    }
  }
}
