import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:startapp_sdk/startapp.dart';

class EasyStartAppInterstitialAd extends EasyAdBase {
  EasyStartAppInterstitialAd(String adUnitId, StartAppSdk startAppSdkParam)
      : super(adUnitId) {
    startAppSdk = startAppSdkParam;
  }

  StartAppSdk? startAppSdk;

  bool _isAdLoaded = false;

  @override
  AdNetwork get adNetwork => AdNetwork.yandex;

  @override
  AdUnitType get adUnitType => AdUnitType.interstitial;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  void dispose() => _isAdLoaded = false;

  StartAppInterstitialAd? _interstitialAd;

  @override
  Future<void> load() async {
    loadInterstitialAd();
  }

  void loadInterstitialAd() {
    startAppSdk?.loadInterstitialAd(
      onAdHidden: () {
        // do something
        _interstitialAd?.dispose();
        _interstitialAd = null;
        onAdDismissed?.call(adNetwork, adUnitType, null);
      },
      onAdNotDisplayed: () {
        _isAdLoaded = false;
        onAdFailedToLoad?.call(adNetwork, adUnitType, null,
            'Error occurred while loading $adNetwork ad');
        _interstitialAd?.dispose();
        _interstitialAd = null;
      },
      onAdClicked: () {
        onAdClicked?.call(adNetwork, adUnitType, null);
      },
    ).then((interstitialAd) {
      _interstitialAd = interstitialAd;
      _isAdLoaded = true;
      onAdLoaded?.call(adNetwork, adUnitType, 'Loaded');
    }).onError<StartAppException>((ex, stackTrace) {
      _isAdLoaded = false;
      onAdFailedToLoad?.call(
          adNetwork, adUnitType, null, 'Error occurred while loading ${ex}');
    }).onError((error, stackTrace) {});
  }

  @override
  show() {
    if (!_isAdLoaded) return;

    _interstitialAd?.show();

    _isAdLoaded = false;
  }
}
