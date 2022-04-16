import 'dart:typed_data';

class QueryPartitionInfo {
  int Recipient;
  int PartitionID;

  QueryPartitionInfo(int recipient, partitionID){
    this.Recipient = recipient;
    this.PartitionID = partitionID;
  }

  Int8List toRaw(){
    return new Int8List.fromList([Recipient, PartitionID]);
  }
}
