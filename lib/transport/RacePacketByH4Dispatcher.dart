import 'dart:typed_data';

import 'package:aiwa_technology/Helper.dart';
import 'package:aiwa_technology/fota/FotaManager.dart';

class RacePacketByH4Dispatcher {
  static final int RACE_BY_H4_START = 0x05;

  static bool isRaceByH4Collected(Int8List packet) {
    return packet[0] == RACE_BY_H4_START;
  }

  void parseSend(Int8List packet) {

  int raceId = Helper.bytesToInt(packet[5], packet[4]);

  int raceType = packet[1];

  int payloadLength = Helper.bytesToInt(packet[3], packet[2]) - 2;

  int payloadStartIdx = 6;

  FotaManager.handleRespOrInd(raceId, packet, raceType);
  /*for (OnRacePacketListener respListener : mRacePacketListeners.values()) {
  if (respListener != null) {
  respListener.handleRespOrInd(raceId, packet, raceType);
  }*/
  }

  }
