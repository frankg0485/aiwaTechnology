// STAGE 0
import 'dart:typed_data';

import 'package:aiwa_technology/RaceCommand/constant/RaceID.dart';
import 'package:aiwa_technology/RaceCommand/constant/RaceType.dart';
import 'package:aiwa_technology/RaceCommand/constant/Recipient.dart';
import 'package:aiwa_technology/RaceCommand/packet/RacePacket.dart';
import 'package:aiwa_technology/fota/FotaManager.dart';
import 'package:aiwa_technology/fota/FotaStage.dart';
import 'package:aiwa_technology/fota/RaceCmdQueryState.dart';
import 'package:aiwa_technology/fota/StatusCode.dart';

import 'RespFotaState.dart';

class FotaStage_QueryState extends FotaStage {
  Int8List mRecipients;
//    private RespFotaState.dart[] mRespFotaStates;

  FotaStage_QueryState(FotaManager mgr, Int8List recipients) : super(mgr) {
    mRaceId = RaceID.RACE_FOTA_QUERY_STATE;
    mRaceRespType = RaceType.INDICATION;

    mRecipients = recipients;
  }

  @override
  void genRacePackets() {
    RacePacket cmd = null;
    //try {
    cmd = createRacePacket();
    //} catch (IOException e) {
    //e.printStackTrace();
    //return;
    //

    placeCmd(cmd);
  }

  @override
  void placeCmd(RacePacket cmd) {
    mCmdPacketQueue.add(cmd);
    //mCmdPacketMap.put(TAG, cmd); // only one cmd needs to check resp
  }

  RacePacket createRacePacket() {
    Int8List outputStream = new Int8List.fromList([mRecipients.length] + mRecipients);
    //"RecipientCount (1 byte),
    //{
    //    Recipient (1 byte)
    //} [%RecipientCount%]"
    //outputStream.add(mRecipients.length);
    //outputStream += mRecipients;

    Int8List payload = outputStream;

    RacePacket cmd = new RaceCmdQueryState();
    cmd.setPayload(payload);
    return cmd;
  }

  @override
  void parsePayloadAndCheckCompleted(
      int raceId, Int8List packet, int status, int raceType) {
//mAirohaLink.logToFile(TAG, "RACE_FOTA_QUERY_STATE resp status: " + status);
    print("RACE_FOTA_QUERY_STATE resp status: " + status.toString());
//RacePacket cmd = mCmdPacketMap.get(TAG);

    if (status == StatusCode.FOTA_ERRCODE_SUCESS) {
//cmd.setIsRespStatusSuccess();
    } else {
      return;
    }

//Status (1 byte),
//RecipientCount (1 byte),
//{
//    Recipient (1 byte),
//    FotaState (2 bytes)
//} [%RecipientCount%]

    List<RespFotaState> extracted = RespFotaState.extractRespFotaStates(packet);
    passInfoToMgr(extracted);
  }

  void passInfoToMgr(List<RespFotaState> respFotaStates) {
    respFotaStates.forEach((RespFotaState rfs) {
      if (rfs.Recipient == Recipient.DontCare) {
        mOtaMgr.setAgentFotaState(rfs.FotaState);
      }
    });
  }
}
