// STAGE 0
import 'dart:typed_data';

import 'package:aiwa_technology/RaceCommand/constant/RaceID.dart';
import 'package:aiwa_technology/RaceCommand/constant/RaceType.dart';
import 'package:aiwa_technology/RaceCommand/packet/RacePacket.dart';
import 'package:aiwa_technology/fota/FotaManager.dart';
import 'package:aiwa_technology/fota/FotaStage.dart';
import 'package:aiwa_technology/fota/StatusCode.dart';

class FotaStage_GetVersion extends FotaStage {
  Int8List mRecipients;

  FotaStage_GetVersion(FotaManager mgr, Int8List recipients) : super(mgr) {
    mRaceId = RaceID.RACE_FOTA_GET_VERSION;
    mRaceRespType = RaceType.INDICATION;

    mRecipients = recipients;
  }

  @override
  void genRacePackets() {
    Int8List outputStream =
        new Int8List.fromList([mRecipients.length] + mRecipients);
    //"RecipientCount (1 byte),
    //{
    //    Recipient (1 byte)
    //} [%RecipientCount%]"
    //try {
    //} catch (IOException e) {
    //e.printStackTrace();
    //}

    Int8List payload = outputStream;

    RacePacket cmd =
        new RacePacket(RaceType.CMD_NEED_RESP, RaceID.RACE_FOTA_GET_VERSION);
    cmd.setPayload(payload);

    placeCmd(cmd);
  }

  @override
  void placeCmd(RacePacket cmd) {
    mCmdPacketQueue.add(cmd);
    //mCmdPacketMap.put(TAG, cmd);
  }

  @override
  void parsePayloadAndCheckCompeted(
      int raceId, Int8List packet, int status, int raceType) {
    //mAiwaLink.logToFile(TAG, "RACE_FOTA_GET_VERSION resp status: " + status);
    print("RACE_FOTA_GET_VERSION resp status: " + status.toString());
    //RacePacket cmd = mCmdPacketMap.get(TAG);

    if (status == StatusCode.FOTA_ERRCODE_SUCESS) {
      //cmd.setIsRespStatusSuccess();
    } else {
      return;
    }

    //"Status (1 byte),
    //RecipientCount (1 byte),
    //{
    //    Recipient (1 byte),
    //    VersionLength (1 byte),
    //    Version (%VersionLength%)
    //} [%RecipientCount%]"
    int idx = RacePacket.IDX_PAYLOAD_START + 1;

    int recipientCount = packet[idx];
    idx = idx + 1;

    if (recipientCount == 1) {
      int recipient = packet[idx];
      idx = idx + 1;

      int versionLength = packet[idx];
      idx = idx + 1;

      Int8List version = new Int8List(versionLength);
      version = packet.sublist(idx, idx + versionLength);
      idx = idx + versionLength;

      passToMgr(version);
    }
  }

  void passToMgr(Int8List version) {
    mOtaMgr.setAgentVersion(version);
  }
}
