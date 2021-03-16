import 'dart:collection';
import 'dart:typed_data';

import 'package:aiwa_technology/AgentClientEnum.dart';
import 'package:aiwa_technology/fota/FotaStage.dart';
import 'package:aiwa_technology/fota/FotaStage_GetBattery.dart';

class FotaManager {
  static Queue<FotaStage> mStagesQueue = Queue<FotaStage>();
  static FotaStage mCurrentStage;

  void querySingleFotaInfo(int role) {
    print("FotaManager: query single fota info");
    //renewStageQueue();

    if(role == AgentClientEnum.AGENT){
      // 2018.01.07 [BTA-3177] - update the nv item at the head
      /*mStagesQueue.offer(new FotaStage_ReclaimNvkey(this, (short)1));
      mStagesQueue.offer(new FotaStage_WriteNV(this, NvKeyId.NV_RECONNECT, new byte[]{0x00}));

      QueryPartitionInfo[] queryPartitionInfos = createQueryFotaAndFilesystemPartitionInfos();
      mStagesQueue.offer(new FotaStage_00_QueryPartitionInfo(this, queryPartitionInfos));

      byte[] recipients = new byte[]{Recipient.DontCare};
      mStagesQueue.offer(new FotaStage_00_GetVersion(this, recipients));
      mStagesQueue.offer(new FotaStage_00_GetFwInfo(this, recipients));
      mStagesQueue.offer(new FotaStage_00_QueryState(this, recipients));

      // 2018.01.07 [BTA-3177] - query the battery at the tail*/
      mStagesQueue.add(FotaStage_GetBattery());
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

  static void handleRespOrInd(int raceId, Int8List packet, int raceType) {
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


  }
  void startPollStageQueue() {
    print("FotaManager: start poll stage queue");
    //mTotalStageCount = mStagesQueue.size();
    //mCompletedStageCount = 0;

    FotaManager.mCurrentStage = FotaManager.mStagesQueue.removeFirst();
    FotaManager.mCurrentStage.start();
  }
}