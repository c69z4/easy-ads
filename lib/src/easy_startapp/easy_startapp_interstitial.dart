import 'dart:developer';

import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';

import 'package:startapp_sdk/startapp.dart';

class EasyStartAppInterstitialAd extends EasyAdBase {
  final StartAppSdk _startAppSdk;
  EasyStartAppInterstitialAd(String adUnitId, this._startAppSdk)
      : super(adUnitId);

  bool _isAdLoaded = false;

  @override
  AdNetwork get adNetwork => AdNetwork.startApp;

  @override
  AdUnitType get adUnitType => AdUnitType.interstitial;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  void dispose() => _isAdLoaded = false;

  StartAppInterstitialAd? _interstitialAd;

  @override
  Future<void> load() async {
    _interstitialAd = await _startAppSdk.loadInterstitialAd(
      prefs: const StartAppAdPreferences(adTag: 'home_screen'),
      onAdHidden: () {
        // do something
        // _interstitialAd?.dispose();
        _interstitialAd = null;
        onAdDismissed?.call(adNetwork, adUnitType, null);
      },
      onAdNotDisplayed: () {
        _isAdLoaded = false;
        onAdFailedToLoad?.call(adNetwork, adUnitType, null,
            'Error occurred while loading $adNetwork ad');
        // _interstitialAd?.dispose();
        _interstitialAd = null;
      },
      onAdClicked: () {
        onAdClicked?.call(adNetwork, adUnitType, null);
      },
    );
    _isAdLoaded = true;
    log('_interstitialAd-->${_interstitialAd}');

    //     .then((interstitialAd) {
    //   _interstitialAd = interstitialAd;
    //   _isAdLoaded = true;
    //   onAdLoaded?.call(adNetwork, adUnitType, 'Loaded');
    // }).onError<StartAppException>((ex, stackTrace) {
    //   _isAdLoaded = false;
    //   onAdFailedToLoad?.call(
    //       adNetwork, adUnitType, null, 'Error occurred while loading ${ex}');
    //   debugPrint("Error loading Interstitial ad: ${ex.message}");
    // }).onError((error, stackTrace) {});
  }

  @override
  show() {
    log('_isAdLoaded-->${_isAdLoaded}');
    if (!_isAdLoaded) return;

    _interstitialAd?.show();

    _isAdLoaded = false;
  }
}
