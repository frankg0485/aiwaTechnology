import 'dart:collection';
import 'dart:typed_data';
import 'package:aiwa_technology/fota/AiwaLink.dart';
import 'package:aiwa_technology/RaceCommand/packet/RacePacket.dart';
import 'package:aiwa_technology/fota/StatusCode.dart';

class FotaStage {
  bool mIsStopped = false;

  Queue<RacePacket> mCmdPacketQueue = Queue<RacePacket>();
  AiwaLink mAiwaLink;

  int mRaceId = 0;

  bool mIsRespSuccess;

  int mStatusCode = 0xFF;

  int mCompletedTaskCount = 0;

  FotaStage(/*AirohaRaceOtaMgr mgr*/) {
    mAiwaLink = AiwaLink();
    //mOtaMgr = mgr;
    //mAirohaLink = mgr.getAirohaLink();
    /*mCmdPacketQueue = new ConcurrentLinkedQueue<>();
    mCmdPacketMap = new LinkedHashMap<>();
    mRaceRespType = RaceType.RESPONSE;

    TAG = getClass().getSimpleName();*/
  }

  void genRacePackets() {}

  void placeCmd(RacePacket cmd){

  }

  void start() {
    print("FotaStage: process started");
    if (mIsStopped) return;

    //mStartTime = System.currentTimeMillis();

    genRacePackets();
    //mInitQueueSize = mCmdPacketQueue.size();
    //mAirohaLink.logToFile(TAG, "mInitQueueSize: " + mInitQueueSize);
    prePoolCmdQueue();
  }

  void prePoolCmdQueue() {
    print("FotaStage: prepool command queue");
    if (mCmdPacketQueue.length != 0) {
      /*if(mOtaMgr.isLongPacketMode()){
        poolCmdToSendLongPacketMode();
        return;
      }*/

      /*if (mCmdPacketQueue.length >= 2) {
        mAirohaLink.logToFile(TAG, " PrePollSize = " + getPrePollSize());
        for (int i = 0; i < getPrePollSize(); i++) {
          poolCmdToSend();
        }
      } else {*/
      poolCmdToSend();
      //}
    }
  }

  void poolCmdToSend() {
    print("FotaStage: pool command to send");
    RacePacket cmd = mCmdPacketQueue.removeFirst();
    if (cmd != null) {
      mAiwaLink.sendCommand(cmd.getRaw());

      /*if (cmd.isNeedResp()) {
        mOtaMgr.startRespTimer();
      }*/
    }
  }

  void parsePayloadAndCheckCompeted(
      final int raceId, final Int8List packet, int status, int raceType) {}

  void handleResp(final int raceId, final Int8List packet, int raceType) {
    print("FotaStage: handle response");
    print(raceId);
    print(mRaceId);
    print("HHHHHHHHHHHHHHHHH");
    if (raceId != mRaceId) return;

    int idx = RacePacket.IDX_PAYLOAD_START;

    //mAirohaLink.logToFile(TAG, "Rx packet: " + Converter.byte2HexStr(packet));

    /*if(mIsRelay){
  // need to strip relay header
  // start from the RacePacket.IDX_PAYLOAD_START

  //             (pass to dst notification)    (race cmd rsp from partner)
  //Agent:  05 5D 0E 00 01 0D 05 04 05 5B 06 00 00 0D 00 00 03 03

  // stripped: 05 5B 06 00 00 0D 00 00 03 03

  byte[] stripRelayHeaderPacket = RelayRespExtracter.extractRelayRespPacket(packet);
  byte extractedRaceType = RelayRespExtracter.extractRaceType(stripRelayHeaderPacket);
  int extractedRaceId = RelayRespExtracter.extractRaceId(stripRelayHeaderPacket);

  if(extractedRaceType != mRelayRaceRespType || extractedRaceId != mRelayRaceId)
  return;

  mStatusCode = RelayRespExtracter.extractStatus(stripRelayHeaderPacket);

  parsePayloadAndCheckCompeted(extractedRaceId, stripRelayHeaderPacket, mStatusCode, extractedRaceType);
  }else {*/
    mStatusCode = packet[idx];
    parsePayloadAndCheckCompeted(raceId, packet, mStatusCode, raceType);
    //}

    if (mStatusCode == StatusCode.FOTA_ERRCODE_SUCESS) {
      mIsRespSuccess = true;

      mCompletedTaskCount++;
    } else {
      mIsRespSuccess = false;
    }

    /*if(mOtaMgr.isLongPacketMode()){
  mWaitingRespCount--;

  mAirohaLink.logToFile(TAG, "mWaitingRespCount: " + mWaitingRespCount);
  }*/
  }
}
