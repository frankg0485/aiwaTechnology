// STAGE 0
import 'dart:typed_data';

import 'package:aiwa_technology/RaceCommand/constant/RaceID.dart';
import 'package:aiwa_technology/RaceCommand/constant/RaceType.dart';
import 'package:aiwa_technology/RaceCommand/packet/RacePacket.dart';
import 'package:aiwa_technology/fota/FotaManager.dart';
import 'package:aiwa_technology/fota/FotaStage.dart';
import 'package:aiwa_technology/fota/StatusCode.dart';

class FotaStage_GetFwInfo extends FotaStage {
  Int8List mRecipients;

  FotaStage_GetFwInfo(FotaManager mgr, Int8List recipients) : super(mgr) {
  //super(mgr);

  mRaceId = RaceID.RACE_FOTA_GET_AE_INFO;
  mRaceRespType = RaceType.INDICATION;

  mRecipients = recipients;
  }

  @override
  void genRacePackets() {
    Int8List outputStream = new Int8List(0);
    //"RecipientCount (1 byte),
    //{
    //    Recipient (1 byte)
    //} [%RecipientCount%]"
    outputStream.add(mRecipients.length);
    //try {
      outputStream += mRecipients;
    //} catch (IOException e) {
    //e.printStackTrace();
    //}

    Int8List payload = outputStream;

    //Cmd format
    //05 + type + length(2 byte) + CMD id(2 byte) + RecipientCount(1 byte) + Recipient(1 byte)
    // 05  5A     0300             091C                                      FF(0: agent, 1: partner, 0xFF: don't care)
    //Rsp format
    //05 + type + length(2 byte) + CMD id(2 byte) + status(1 byte) + RecipientCount(1 byte) + Recipient(1 byte) + payload

    RacePacket cmd = new RacePacket(RaceType.CMD_NEED_RESP, RaceID.RACE_FOTA_GET_AE_INFO);
    cmd.setPayload(payload);

    placeCmd(cmd);
  }

  @override
  void placeCmd(RacePacket cmd) {
    mCmdPacketQueue.add(cmd);
    //mCmdPacketMap.put(TAG, cmd);
  }

  @override
  void parsePayloadAndCheckCompeted(int raceId, Int8List packet, int status, int raceType) {
  //mAiwaLink.logToFile(TAG, "FotaStage_00_GetFwInfo resp status: " + status);
    print("FotaStage_00_GetFwInfo resp status: " + status.toString());

  //RacePacket cmd = mCmdPacketMap.get(TAG);

  if (status == StatusCode.FOTA_ERRCODE_SUCESS){
  //cmd.setIsRespStatusSuccess();
  } else {
  return;
  }

  //Rsp format
  //05 + type + length(2 byte) + CMD id(2 byte) + status(1 byte) + RecipientCount(1 byte) + Recipient(1 byte) + payload
  int idx = RacePacket.IDX_PAYLOAD_START+1;

  int recipientCount = packet[idx];
  idx = idx + 1;

  int aeLength = packet[9];
  Int8List info = new Int8List(aeLength);
  //System.arraycopy(packet, 10, info, 0, (int)aeLength);
  passToMgr(info);
  }

  void passToMgr(Int8List info){
  //mOtaMgr.setAgentFwInfo(info);
  }
}
