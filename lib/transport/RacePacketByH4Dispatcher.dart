import 'dart:collection';
import 'dart:typed_data';

import 'package:aiwa_technology/util/Converter.dart';
import 'package:aiwa_technology/fota/FotaManager.dart';
import 'package:aiwa_technology/transport/OnRacePacketListener.dart';



class RacePacketByH4Dispatcher {
  static final int RACE_BY_H4_START = 0x05;

  HashMap<String, OnRacePacketListener> mRacePacketListeners = HashMap<String, OnRacePacketListener>();
  static bool isRaceByH4Collected(Int8List packet) {
    return packet[0] == RACE_BY_H4_START;

  }

  void registerRacePacketListener(String subscriber, OnRacePacketListener listener) {
    mRacePacketListeners.putIfAbsent(subscriber, () => listener);
  }

  void parseSend(Int8List packet) {
  int raceId = Converter.bytesToInt(packet[5], packet[4]);

  int raceType = packet[1];

  int payloadLength = Converter.bytesToInt(packet[3], packet[2]) - 2;

  int payloadStartIdx = 6;

  for (var respListener in mRacePacketListeners.values) {
    if (respListener != null) {
      respListener.handleRespOrInd(raceId, packet, raceType);
    }
  }
  //FotaManager.handleRespOrInd(raceId, packet, raceType);
  /*for (OnRacePacketListener respListener : mRacePacketListeners.values()) {
  if (respListener != null) {
  respListener.handleRespOrInd(raceId, packet, raceType);
  }*/
  }

  }
