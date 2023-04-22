import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:flutter_ironsource_x/ironsource.dart';

class EasyIronSourceInterstitialAd extends EasyAdBase with IronSourceListener {
  EasyIronSourceInterstitialAd(String adUnitId) : super(adUnitId);

  bool _isAdLoaded = false;

  @override
  AdUnitType get adUnitType => AdUnitType.interstitial;

  @override
  AdNetwork get adNetwork => AdNetwork.ironSource;

  @override
  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  void dispose() => _isAdLoaded = false;

  @override
  Future<void> load() async {
    // print('iron isAdLoaded load: $_isAdLoaded');

    if (_isAdLoaded) return;
    if (adUnitType == AdUnitType.interstitial) {
      IronSource.loadInterstitial();
    } //
    // reward no necesita ser cargado(revisar...)
  }

  @override
  Future<void> show() async {
    if (!_isAdLoaded) return;
    if (adUnitType == AdUnitType.interstitial) {
      if ((await IronSource.isInterstitialReady()) != true) {
        await load();
      }
      final isCapped =
          await IronSource.isInterstitialPlacementCapped(adUnitId) as bool?;
      if (isCapped != true) {
        await IronSource.showInterstitial(placementName: adUnitId);
      }
    } else {
      if (await IronSource.isRewardedVideoAvailable()) {
        await IronSource.showRewardedVideo();
      }
    }
    _isAdLoaded = false;
  }

  @override
  void onInterstitialAdReady() {
    _isAdLoaded = true;
    onAdLoaded?.call(adNetwork, adUnitType, null);
  }

  @override
  void onInterstitialAdLoadFailed(error) {
    _isAdLoaded = false;
    onAdFailedToLoad?.call(adNetwork, adUnitType, null,
        'Error occurred while loading $adNetwork ad');
  }

  @override
  void onInterstitialAdShowSucceeded() {
    onAdShowed?.call(adNetwork, adUnitType, null);
  }

  @override
  void onInterstitialAdShowFailed(error) {
    onAdFailedToShow?.call(adNetwork, adUnitType, null,
        'Error occurred while showing $adNetwork ad');
  }

  @override
  void onInterstitialAdClicked() {
    onAdClicked?.call(adNetwork, adUnitType, null);
  }

  @override
  void onInterstitialAdClosed() {
    onAdDismissed?.call(adNetwork, adUnitType, null);
    load(); //carga el siguiente ok
  }

  @override
  void onInterstitialAdOpened() {}
}
