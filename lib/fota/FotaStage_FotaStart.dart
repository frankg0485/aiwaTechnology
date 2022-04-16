import 'dart:typed_data';
import 'package:aiwa_technology/RaceCommand/constant/RaceID.dart';
import 'package:aiwa_technology/RaceCommand/constant/RaceType.dart';
import 'package:aiwa_technology/RaceCommand/packet/RacePacket.dart';
import 'package:aiwa_technology/fota/FotaManager.dart';
import 'package:aiwa_technology/fota/FotaStage.dart';
import 'package:aiwa_technology/fota/StatusCode.dart';


// STAGE 0
class FotaStage_FotaStart extends FotaStage {
  Int8List mRecipients;

  FotaStage_FotaStart(FotaManager mgr, Int8List recipients): super(mgr) {
    mRaceId = RaceID.RACE_FOTA_START;
    mRaceRespType = RaceType.INDICATION;

    mRecipients = recipients;
  }

  @override
  void genRacePackets() {
    //"RecipientCount (1 byte),
    //{
    //    Recipient (1 byte)
    //} [%RecipientCount%]"
    Int8List outputStream = new Int8List.fromList([mRecipients.length] + mRecipients);
    //outputStream.add(mRecipients.length);
    //try {
      //outputStream += mRecipients;
    //} catch (IOException e) {
    //e.printStackTrace();
    //}
    Int8List payload = outputStream;

    RacePacket cmd = new RacePacket(RaceType.CMD_NEED_RESP, RaceID.RACE_FOTA_START);
    cmd.setPayload(payload);

    placeCmd(cmd);
  }

  @override
  void placeCmd(RacePacket cmd) {
    mCmdPacketQueue.add(cmd);
    //mCmdPacketMap.add(TAG, cmd);
  }

  @override
  void parsePayloadAndCheckCompeted(int raceId, Int8List packet, int status, int raceType) {
  //mAirohaLink.logToFile(TAG, "resp status: " + status);
  print("FotaStage_FotaStart resp status: " + status.toString());
  //RacePacket cmd = mCmdPacketMap.get(TAG);
  if (status == StatusCode.FOTA_ERRCODE_SUCESS) {
  //cmd.setIsRespStatusSuccess();
  } else {
  //cmd.increaseRetryCounter();
  return;
  }

  //"Status (1 byte),
  //RecipientCount (1 byte),
  //{
  //    Recipient (1 byte)
  //} [%RecipientCount%]"

  return;
  }
}
