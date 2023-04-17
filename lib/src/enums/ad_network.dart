import 'package:flutter/foundation.dart';

enum AdNetwork { any, admob, appLovin, unity, facebook, ironSource }

extension AdNetworkExtension on AdNetwork {
  String get value => describeEnum(this);
}
