import 'dart:typed_data';

import 'package:aiwa_technology/RaceCommand/packet/RacePacket.dart';

class RespQueryPartitionInfo {
  //PartitionInfoCount (1 byte),
  //{
  //    Recipient (1 byte),
  //    PartitionID (1 byte),
  //    StorageType (1 byte),
  //    Address (4 bytes),
  //    Length (4 bytes)
  //} [%PartitionInfoCount%]
  int Recipient;
  int PartitionID;
  int StorageType;
  Int8List Address = new Int8List(4);
  Int8List Length = new Int8List(4);


  static List<RespQueryPartitionInfo> extractRespPartitionInfo(Int8List packet){
  //Status (1 byte),
  //PartitionInfoCount (1 byte),
  //{
  //    Recipient (1 byte),
  //    PartitionID (1 byte),
  //    StorageType (1 byte),
  //    Address (4 bytes),
  //    Length (4 bytes)
  //} [%PartitionInfoCount%]

  int idx = RacePacket.IDX_PAYLOAD_START + 1;

  int partitionInfoCount = packet[idx];
  idx = idx + 1;

  List<RespQueryPartitionInfo> respQueryPartitionInfos = new List<RespQueryPartitionInfo>(partitionInfoCount);

  for(int i = 0; i < partitionInfoCount; i++){
  respQueryPartitionInfos[i] = new RespQueryPartitionInfo();
  respQueryPartitionInfos[i].Recipient = packet[idx];
  idx = idx + 1;

  respQueryPartitionInfos[i].PartitionID = packet[idx];
  idx = idx + 1;

  respQueryPartitionInfos[i].StorageType = packet[idx];
  idx = idx + 1;

  //System.arraycopy(packet, idx, respQueryPartitionInfos[i].Address, 0, 4);
  List.copyRange(respQueryPartitionInfos[i].Address, 0, packet, idx, idx + 4);
  idx = idx + 4;

  //System.arraycopy(packet, idx, respQueryPartitionInfos[i].Length, 0, 4);
  List.copyRange(respQueryPartitionInfos[i].Length, 0, packet, idx, idx + 4);
  idx = idx + 4;
  }

  return respQueryPartitionInfos;
  }
}
