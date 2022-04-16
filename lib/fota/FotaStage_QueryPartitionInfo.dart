// STAGE 0
import 'dart:convert';
import 'dart:typed_data';

import 'package:aiwa_technology/RaceCommand/constant/RaceID.dart';
import 'package:aiwa_technology/RaceCommand/constant/RaceType.dart';
import 'package:aiwa_technology/RaceCommand/constant/Recipient.dart';
import 'package:aiwa_technology/RaceCommand/packet/RacePacket.dart';
import 'package:aiwa_technology/fota/FotaManager.dart';
import 'package:aiwa_technology/fota/FotaStage.dart';
import 'package:aiwa_technology/fota/QueryPartitionInfo.dart';
import 'package:aiwa_technology/fota/RespQueryPartitionInfo.dart';
import 'package:aiwa_technology/fota/StatusCode.dart';

class FotaStage_QueryPartitionInfo extends FotaStage {
  List<QueryPartitionInfo> mQueryPartitionInfos;

  FotaStage_QueryPartitionInfo(
      FotaManager mgr, List<QueryPartitionInfo> queryPartitionInfos)
      : super(mgr) {
    mRaceId = RaceID.RACE_FOTA_PARTITION_INFO_QUERY;
    mRaceRespType = RaceType.INDICATION;
    mQueryPartitionInfos = queryPartitionInfos;
  }

  @override
  void genRacePackets() {
    RacePacket cmd = null;
    //try {
    cmd = createRacePacket();
    //} catch (IOException e) {
    //rint("error with querying partition info");
    //return;
    //}

    placeCmd(cmd);
  }

  @override
  void placeCmd(RacePacket cmd) {
    mCmdPacketQueue.add(cmd);
    //mCmdPacketMap.put(TAG, cmd); // only one cmd needs to check resp
  }

  RacePacket createRacePacket() {
    //PartitionInfoCount (1 byte),
    //{
    //    Recipient (1 byte),
    //    PartitionID (1 byte)
    //} [%PartitionInfoCount%]

    Int8List byteArrayOutputStream = new Int8List(0);
    byteArrayOutputStream.add(mQueryPartitionInfos.length);
    for (int i = 0; i < mQueryPartitionInfos.length; i++) {
      byteArrayOutputStream += mQueryPartitionInfos[i].toRaw();
    }

    Int8List payload = byteArrayOutputStream;

    RacePacket cmd = new RacePacket.fromID(
        RaceType.CMD_NEED_RESP, RaceID.RACE_FOTA_PARTITION_INFO_QUERY, payload);

    return cmd;
  }

  @override
  void parsePayloadAndCheckCompleted(
      int raceId, Int8List packet, int status, int raceType) {
//mAirohaLink.logToFile(TAG, "RACE_FOTA_PARTITION_INFO_QUERY resp status: " + status);
    print("RACE_FOTA_PARTITION_INFO_QUERY resp status: " + status.toString());
//RacePacket cmd = mCmdPacketMap.get(TAG);
    if (status == StatusCode.FOTA_ERRCODE_SUCESS) {
//cmd.setIsRespStatusSuccess();
    } else {
      return;
    }

    extractPartitionInfoFromPacket(packet);
  }

  void extractPartitionInfoFromPacket(Int8List packet) {
    FotaStage.gRespQueryPartitionInfos =
        RespQueryPartitionInfo.extractRespPartitionInfo(packet);

    if (FotaStage.gRespQueryPartitionInfos.length == 2) {
// check Fota partition and FileSystem partition address

      RespQueryPartitionInfo partitionInfo1 =
          FotaStage.gRespQueryPartitionInfos[0];
      RespQueryPartitionInfo partitionInfo2 =
          FotaStage.gRespQueryPartitionInfos[1];

// for 153X
      if (partitionInfo1.Recipient == Recipient.DontCare &&
          partitionInfo2.Recipient == Recipient.DontCare) {
        int addr1 = partitionInfo1.Address as int;
        int addr2 = partitionInfo2.Address as int;

        if (addr1 == addr2) {
          mOtaMgr.setNeedToUpdateFileSystem(true);
        }
      }
    }
  }
}
