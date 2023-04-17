import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';

class EasyApplovinBannerAd extends EasyAdBase {
  EasyApplovinBannerAd(String adUnitId) : super(adUnitId);

  @override
  AdUnitType get adUnitType => AdUnitType.banner;
  @override
  AdNetwork get adNetwork => AdNetwork.ironSource;

  @override
  void dispose() {}

  @override
  bool get isAdLoaded => false;

  @override
  Future<void> load() async {}

  @override
  dynamic show() {}
}
