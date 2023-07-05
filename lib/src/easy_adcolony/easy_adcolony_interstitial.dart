import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:adcolony_flutter/adcolony_flutter.dart';

class EasyAdColonyInterstitialAd extends EasyAdBase {
  EasyAdColonyInterstitialAd(
    String adUnitId,
  ) : super(adUnitId);

  bool _isAdLoaded = false;

  @override
  AdNetwork get adNetwork => AdNetwork.adColony;

  @override
  AdUnitType get adUnitType => AdUnitType.interstitial;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  void dispose() => _isAdLoaded = false;

  @override
  Future<void> load() async {
    await AdColony.request(adUnitId, _listener);
  }

  void _listener(AdColonyAdListener? event, int? reward) async {
    if (event == AdColonyAdListener.onRequestFilled) {
      if (await AdColony.isLoaded()) {
        _isAdLoaded = true;
        onAdLoaded?.call(adNetwork, adUnitType, null);
      } else {
        _isAdLoaded = false;
        onAdFailedToLoad?.call(adNetwork, adUnitType, null,
            'Error occurred while loading $adNetwork ad');
      }
    } else if (event == AdColonyAdListener.onClicked) {
      onAdClicked?.call(adNetwork, adUnitType, null);
    } else if (event == AdColonyAdListener.onClosed) {
      onAdDismissed?.call(adNetwork, adUnitType, null);
    } else if (event == AdColonyAdListener.onRequestNotFilled) {
      _isAdLoaded = false;
      onAdFailedToLoad?.call(adNetwork, adUnitType, null,
          'Error occurred while loading $adNetwork ad');
    }
  }

  @override
  show() {
    if (!_isAdLoaded) return;
    AdColony.show();
    _isAdLoaded = false;
  }
}
