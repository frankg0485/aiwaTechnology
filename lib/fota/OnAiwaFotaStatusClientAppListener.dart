import 'package:aiwa_technology/fota/SingleFotaInfo.dart';

abstract class OnAiwaFotaStatusClientAppListener {
  void onSingleFotaInfoUpdated(SingleFotaInfo info);
}