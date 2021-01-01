import 'package:aiwa_technology/RaceCommand/constant/RaceID.dart';
import 'package:aiwa_technology/RaceCommand/constant/RaceType.dart';
import 'package:aiwa_technology/RaceCommand/packet/RacePacket.dart';

class RaceCmdQueryState extends RacePacket {
  RaceCmdQueryState() :
        super.fromID(RaceType.CMD_NEED_RESP, RaceID.RACE_FOTA_QUERY_STATE, null);
}