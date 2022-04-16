import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'package:aiwa_technology/RaceCommand/constant/Recipient.dart';
import 'package:aiwa_technology/fota/FotaStage_FotaStart.dart';
import 'package:aiwa_technology/fota/FotaStage_GetFwInfo.dart';
import 'package:aiwa_technology/fota/FotaStage_GetVersion.dart';
import 'package:aiwa_technology/fota/FotaStage_QueryState.dart';
import 'package:aiwa_technology/fota/OnAiwaFotaStatusClientAppListener.dart';
import 'package:aiwa_technology/fota/SingleFotaInfo.dart';
import 'package:aiwa_technology/fotaState/StageEnum.dart';
import 'package:aiwa_technology/util/Converter.dart';
import 'package:convert/convert.dart';

import 'package:aiwa_technology/AgentClientEnum.dart';
import 'package:aiwa_technology/fota/AiwaLink.dart';
import 'package:aiwa_technology/fota/FotaStage.dart';
import 'package:aiwa_technology/fota/FotaStage_GetBattery.dart';
import 'package:aiwa_technology/transport/OnRacePacketListener.dart';
import 'package:aiwa_technology/transport/RacePacketByH4Dispatcher.dart';
import 'package:flutter/cupertino.dart';

class FotaManager {
  Queue<FotaStage> mStagesQueue = Queue<FotaStage>();
  SingleFotaInfo mSingleFotaInfo = new SingleFotaInfo();
  OnRacePacketListener mOnRacePacketListener = OnRacePacketListener();
  Map<String, OnAiwaFotaStatusClientAppListener> mAppLayerListeners =
      new Map<String, OnAiwaFotaStatusClientAppListener>();
  FotaStage mCurrentStage;
  AiwaLink mAiwaLink;
  String mAgentVersion;

  static final String TAG = "FotaManager";
  String mStrAgentStateEnum;
  bool mIsNeedToUpdateFileSystem;
  int mAgentFotaState = StageEnum.APP_UNKNOWN;

  bool mIsNeedToUpdateFileSystem;

  FotaManager(AiwaLink aiwaLink) {
    mAiwaLink = aiwaLink;
    mOnRacePacketListener.handleRespOrInd =
        ((int raceId, Int8List packet, int raceType) {
      print("FotaManager: handle response or ind");
      if (mCurrentStage == null) {
        return;
      }

      //mAirohaLink.logToFile(TAG, "received raceId: " + String.format("%04X", raceId)
      // + ", raceType: " + String.format("%02X", raceType));

      /*if (!mCurrentStage.isExpectedResp(raceType, raceId, packet)) {
      mAirohaLink.logToFile(TAG, "not the expected race ID or Type");
      return;
    }*/

      /*if (mTimerForRetryTask != null) {
      mTimerForRetryTask.cancel();
      mTimerForRetryTask = null;
      mAirohaLink.logToFile(TAG, "mTimerForRetryTask.cancel()");
    }

    if (mTimerForRespTimeout != null) {
      mTimerForRespTimeout.cancel();
      mTimerForRespTimeout = null;
      mAirohaLink.logToFile(TAG, "mTimerForRespTimeout.cancel()");
    }

    if (mCurrentStage.isStopped()) {
      notifyAppListenerError("Stopped unfinished FOTA stages");

      return;
    }*/

      mCurrentStage.handleResp(raceId, packet, raceType);

      /*if (!mCurrentStage.isRespStatusSuccess()) {
      notifyAppListenerError(mCurrentStage.getClass().getSimpleName() + " FAIL! Status: " + String.format("%02X", mCurrentStage.getStatus()));
      return;
    }*/

      /*if (mCurrentStage.isErrorOccurred()) {
      mCurrentStage.stop();

      // 2019.01.09 output all error to file
      mAirohaLink.logToFile(TAG, mCurrentStage.getErrorReason());

      // output to UI, UI callback should give highlight in different color
      notifyAppListenerError(mCurrentStage.getErrorReason());

      return;
    }*/

      /*int completedTaskCount = mCurrentStage.getCompletedTaskCount();
    int totalTaskCount = mCurrentStage.getTotalTaskCount();

    notifyAppListenerProgress(mCurrentStage.getClass().getSimpleName(), completedTaskCount, totalTaskCount);
    */
      /*if (mCurrentStage.isCompleted()) {
      mAirohaLink.logToFile(TAG, "Completed: " + mCurrentStage.getClass().getSimpleName());
      mCompletedStageCount++;

      // check if address/length reasonable
      if (mQueryAddressIsUnreasonable) {
        notifyAppListenerInterrupted("Partition length not matched");
        return;
      }

      String lastStageName = mCurrentStage.getClass().getSimpleName();

      LinkedList<FotaStage> stagesForSkip = null;
      IAirohaFotaStage.SKIP_TYPE skipType = mCurrentStage.getSkipType();
      if (skipType != None) {
        stagesForSkip = mCurrentStage.getStagesForSkip(mCurrentStage.getSkipType());
        if (stagesForSkip != null) {
          mCompletedStageCount = mCompletedStageCount + stagesForSkip.size();
        }
      }

      switch (skipType) {
        case All_stages:
          if (stagesForSkip == null) {
            notifyAppListenerInterrupted("Interrupted: all partitions are the same, skip the other stages.");
          } else {
            reGenStageQueue(skipType);
          }
          break;
        case Compare_stages:
        case Erase_stages:
        case Program_stages:
        case CompareErase_stages:
        case Client_Erase_stages:
          reGenStageQueue(skipType);
          break;
        case Sinlge_StateUpdate_stages:
          if (stagesForSkip != null) {
            reGenStageQueue(skipType);
          }
          break;
      }
*/
      // other stages
      mCurrentStage = mStagesQueue.isEmpty ? null : mStagesQueue.removeFirst();
      if (mCurrentStage != null) {
        //notifyAppListnerStatus("Started: " + mCurrentStage.getClass().getSimpleName());
        print("starting a stage: " + mCurrentStage.toString());
        mCurrentStage.start();
      } else {
        // complete
        //notifyAppListenerCompleted("Completed:" + lastStageName);
        return;
      }
      //} else {
      //mAirohaLink.logToFile(TAG, mCurrentStage.getClass().getSimpleName() + ": send next cmd");
      //actionAfterStageNotCompleted(raceType);
      //}
    });
    mAiwaLink.registerOnRacePacketListener(TAG, mOnRacePacketListener);
    //mAiwaLink.registerOnConnStateListener(TAG, mConnStateListener);
  }

  AiwaLink getAiwaLink() {
    return mAiwaLink;
  }

  void setAgentFwInfo(Int8List info) {
    if (info.length > 20) {
      // new AE format
      Int8List versionInfo = new Int8List(6);
      versionInfo = info.sublist(0, 6);
      Int8List dateInfo = new Int8List(3);
      dateInfo = info.sublist(6, 9);
      Int8List companyInfo = new Int8List(20);
      companyInfo = info.sublist(9, 29);
      Int8List modelInfo = new Int8List(20);
      modelInfo = info.sublist(29, 49);

      String hexStr = hex.encode(companyInfo).replaceAll(" ", "");
      mSingleFotaInfo.agentCompanyName = ascii.decode(hex.decode(hexStr));

      hexStr = hex.encode(modelInfo).replaceAll(" ", "");
      mSingleFotaInfo.agentModelName = ascii.decode(hex.decode(hexStr));

      mSingleFotaInfo.agentReleaseDate = (dateInfo[0] + 2000).toString() +
          "/" +
          dateInfo[1].toString() +
          "/" +
          dateInfo[2].toString();

      int buildNumber = (versionInfo[3] & 0xFF) << 8 | versionInfo[2] & 0xFF;
      int revisionNumber = (versionInfo[5] & 0xFF) << 8 | versionInfo[4] & 0xFF;
    } else {
      // only model name
      String hexStr = hex.encode(info).replaceAll(" ", "");
      mSingleFotaInfo.agentModelName = ascii.decode(hex.decode(hexStr));
    }

    print("SINGLE FOTA INFO: ");
    print(mSingleFotaInfo.agentCompanyName);
    print(mSingleFotaInfo.agentModelName);
    print(mSingleFotaInfo.agentReleaseDate);
  }

  void setNeedToUpdateFileSystem(bool isNeedToUpdateFilesystem) {
    mIsNeedToUpdateFileSystem = isNeedToUpdateFilesystem;
  }

  void setAgentVersion(Int8List version) {
    String hexStr = hex.encode(version).replaceAll(" ", "");
    mAgentVersion = ascii.decode(hex.decode(hexStr));

    print("AGENT VERSION: " + mAgentVersion);
  }

  void querySingleFotaInfo(int role) {
    print("FotaManager: query single fota info");
    //renewStageQueue();

    if (role == AgentClientEnum.AGENT) {
      // 2018.01.07 [BTA-3177] - update the nv item at the head
      /*mStagesQueue.offer(new FotaStage_ReclaimNvkey(this, (short)1));
      mStagesQueue.offer(new FotaStage_WriteNV(this, NvKeyId.NV_RECONNECT, new byte[]{0x00}));

      QueryPartitionInfo[] queryPartitionInfos = createQueryFotaAndFilesystemPartitionInfos();
      mStagesQueue.offer(new FotaStage_00_QueryPartitionInfo(this, queryPartitionInfos));
*/
      Int8List recipients = new Int8List.fromList([Recipient.DontCare]);
      mStagesQueue.add(FotaStage_GetVersion(this, recipients));
      mStagesQueue.add(FotaStage_GetFwInfo(this, recipients));
      /*
      mStagesQueue.offer(new FotaStage_00_QueryState(this, recipients));

      // 2018.01.07 [BTA-3177] - query the battery at the tail*/
      mStagesQueue.add(FotaStage_GetBattery(this));

      mStagesQueue.add(FotaStage_FotaStart(this, recipients));
      mStagesQueue.add(FotaStage_QueryState(this, recipients));
    }

    /*if(role == AgentClientEnum.CLIENT){
      mStagesQueue.offer(new FotaStage_00_GetAvaDst(this));

      mStagesQueue.offer(new FotaStage_ReclaimNvkeyRelay(this, (short)1));
      mStagesQueue.offer(new FotaStage_WriteNVRelay(this, NvKeyId.NV_RECONNECT, new byte[]{0x00}));

      QueryPartitionInfo[] queryPartitionInfos = createQueryFotaAndFilesystemPartitionInfos();
      mStagesQueue.offer(new FotaStage_00_QueryPartitionInfoRelay(this, queryPartitionInfos));

      byte[] recipients = new byte[]{Recipient.DontCare};
      mStagesQueue.offer(new FotaStage_00_GetVersionRelay(this, recipients));
      mStagesQueue.offer(new FotaStage_00_GetFwInfoRelay(this, recipients));
      mStagesQueue.offer(new FotaStage_00_QueryStateRelay(this, recipients));

      // 2018.01.07 [BTA-3177] - query the battery at the tail
      mStagesQueue.offer(new FotaStage_00_GetBatteryRelay(this));
    }*/

    startPollStageQueue();
  }

  void startPollStageQueue() {
    print("FotaManager: start poll stage queue");
    //mTotalStageCount = mStagesQueue.size();
    //mCompletedStageCount = 0;

    mCurrentStage = mStagesQueue.removeFirst();
    mCurrentStage.start();
  }

  void setAgentFotaState(Int8List queryState) {
    mStrAgentStateEnum = Converter.byte2HexStrReverse(queryState);

    // mAirohaLink.logToFile(TAG, "RACE_FOTA_QUERY_STATE resp state: " + mStrAgentStateEnum);

//        notifyStageEnum(mStrAgentStateEnum);
    print(TAG + "\tRACE_FOTA_QUERY_STATE resp state: " + mStrAgentStateEnum);

    mAgentFotaState = (queryState[0] & 0xFF) | ((queryState[1] & 0xFF) << 8);

    handleQueriedStates(mAgentFotaState);

    _notifySingleFotaInfo(mStrAgentStateEnum, mAgentVersion);
  }

  void handleQueriedStates(int queryState) {}

  void _notifySingleFotaInfo(String strFotaState, String strVersion) {
    mSingleFotaInfo.agentFotaState = strFotaState;
    mSingleFotaInfo.agentVersion = strVersion;

    for (OnAiwaFotaStatusClientAppListener listener
        in mAppLayerListeners.values) {
      if (listener != null) {
        listener.onSingleFotaInfoUpdated(mSingleFotaInfo);
      }
    }
  }
}
