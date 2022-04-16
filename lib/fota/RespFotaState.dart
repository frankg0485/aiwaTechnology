import 'dart:typed_data';

import 'package:aiwa_technology/RaceCommand/packet/RacePacket.dart';

class RespFotaState {
  int Recipient;
  Int8List FotaState = new Int8List(2);

  static List<RespFotaState> extractRespFotaStates(Int8List packet) {
    //Status (1 byte),
    //RecipientCount (1 byte),
    //{
    //    Recipient (1 byte),
    //    FotaState (2 bytes)
    //} [%RecipientCount%]

    int idx = RacePacket.IDX_PAYLOAD_START + 1;
    int recipientCount = packet[idx];

    idx = idx + 1;

    List<RespFotaState> respFotaStates = []..length = recipientCount;

    for (int i = 0; i < recipientCount; i++) {
      respFotaStates[i] = new RespFotaState();
      respFotaStates[i].Recipient = packet[idx];
      idx = idx + 1;

      for (int j = idx; j < idx + 2; j++) {
        respFotaStates[i].FotaState[j - idx] = packet[j];
      }

      idx = idx + 2;
    }
    return respFotaStates;
  }
}
