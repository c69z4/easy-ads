import 'package:flutter/foundation.dart';

enum AdNetwork {
  any,
  admob,
  appLovin,
  unity,
  facebook,
  ironSource,
  yandex,
  vungle,
  mytarget,
  adColony,
  startApp
}

extension AdNetworkExtension on AdNetwork {
  String get value => describeEnum(this);
}
