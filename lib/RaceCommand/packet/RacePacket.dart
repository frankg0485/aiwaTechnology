import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class RacePacket {
  static final int IDX_PAYLOAD_START = 6;
  static final int START_CHANNEL_BYTE = 0x05;

  int mbType;
  Int8List mbArrID = Int8List(2);
  int mRaceId;
  Int8List mbArrPayload;
  int mLength;
  Int8List mbArrLength = Int8List(2);

  RacePacket.fromArrayID(
      final int type, final Int8List arrayID, final Int8List payload) {
    mbType = type;

    mbArrID = arrayID;

    mRaceId = (arrayID[0] & 0xFF) | ((arrayID[1] & 0xFF) << 8);

    setPayload(payload);
  }

  RacePacket.fromID(final int type, int id, final Int8List payload) {
    mbType = type;
    mRaceId = id;

    mbArrID = Int8List.fromList([id & 0xFF, (id >> 8) & 0xFF]);

    setPayload(payload);
  }

  RacePacket(final int type, int id) : this.fromID(type, id, null);

  void setPayload(Int8List payload) {
    mbArrPayload = payload;

    mLength = mbArrID.length;
    if (payload != null) {
      mLength = mbArrID.length + payload.length;
      mbArrPayload = payload;
    }

    mbArrLength = Int8List.fromList([mLength & 0xFF, (mLength >> 8) & 0xFF]);
  }

  Int8List getRaw() {
    List<int> list = List<int>();

    list.add(START_CHANNEL_BYTE);

    list.add(mbType);
    list.add(mbArrLength[0]);
    list.add(mbArrLength[1]);

    list.add(mbArrID[0]);
    list.add(mbArrID[1]);

    if (mbArrPayload != null) {
      for (int b in mbArrPayload) {
        list.add(b);
      }
    }

    Int8List arrb = Int8List(list.length);
    print(arrb);
    print(list);
    for (int i = 0; i < arrb.length; i++) {
      arrb[i] = list[i];
    }

    return arrb;
  }
}
