import 'dart:typed_data';

import 'package:aiwa_technology/RaceCommand/constant/RaceID.dart';
import 'package:aiwa_technology/RaceCommand/constant/RaceType.dart';
import 'package:aiwa_technology/RaceCommand/packet/RacePacket.dart';
import 'package:aiwa_technology/fota/FotaManager.dart';
import 'package:aiwa_technology/fota/FotaStage.dart';
import 'package:aiwa_technology/fota/StatusCode.dart';

// STAGE 0
class FotaStage_GetBattery extends FotaStage {
  FotaStage_GetBattery(FotaManager mgr) : super(mgr) {
    mRaceId = RaceID.RACE_BLUETOOTH_GET_BATTERY;
  }

  @override
   void genRacePackets() {
    Int8List payload = Int8List.fromList([0]);//new byte[]{/*mAgentOrClient*/};

    RacePacket cmd = RacePacket.fromID(RaceType.CMD_NEED_RESP, RaceID.RACE_BLUETOOTH_GET_BATTERY, payload);//new RaceCmdTwsGetBattery(payload);
    placeCmd(cmd);
  }

  @override
   void placeCmd(RacePacket cmd) {
    mCmdPacketQueue.add(cmd);
    //mCmdPacketMap.put(TAG, cmd);
  }

  void parsePayloadAndCheckCompeted(int raceId, Int8List packet, int status, int raceType) {
  //mAirohaLink.logToFile(TAG, "resp status: " + status);

  //RacePacket cmd = mCmdPacketMap.get(TAG);
  if (status == StatusCode.FOTA_ERRCODE_SUCESS) {
  //cmd.setIsRespStatusSuccess();
  } else {
  //cmd.increaseRetryCounter();
  return;
  }

  //Status (1 byte),
  //AgentOrClient (1 byte),
  //BatteryStatus (1 byte)

  int agentOrClient = packet[RacePacket.IDX_PAYLOAD_START + 1];
  int batteryStatus = packet[RacePacket.IDX_PAYLOAD_START + 2];

  //mAirohaLink.logToFile(TAG, String.format("target battery level: %d", mOtaMgr.getFotaDualSettings().batteryThreshold));

  //mAirohaLink.logToFile(TAG, String.format("agentOrClient: %d, batteryStatus: %d", agentOrClient, batteryStatus));
  print("**************");
  print("batteryStatus: " + batteryStatus.toString());
  print("**************");
  /*if((batteryStatus & 0xFF) < mOtaMgr.getFotaDualSettings().batteryThreshold) {
  mOtaMgr.notifyBatteryLevelLow();
  mOtaMgr.setFlashOperationAllowed(false);
  mIsErrorOccurred = true;
  mStrErrorReason = FotaErrorMsg.BatteryLow;
  }else {
  mOtaMgr.setFlashOperationAllowed(true);
  }*/

  return;
  }
}