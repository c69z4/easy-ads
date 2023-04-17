import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';

class EasyIronSourceIntertitial extends EasyAdBase
    with IronSourceInterstitialListener {
  EasyIronSourceIntertitial(
    String adUnitId,
  ) : super(adUnitId);

  bool _isAdLoaded = false;

  @override
  AdNetwork get adNetwork => AdNetwork.ironSource;

  @override
  AdUnitType get adUnitType => AdUnitType.interstitial;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  void dispose() => _isAdLoaded = false;

  @override
  Future<void> load() async {
    print('iron isAdLoaded load: $_isAdLoaded');

    if (_isAdLoaded) return;
    if (adUnitType == AdUnitType.interstitial) {
      await IronSource.loadInterstitial();
      // AppLovinMAX.loadInterstitial(adUnitId);
      // _isAdLoaded = await AppLovinMAX.isInterstitialReady(adUnitId) ?? false;
    }
    // _onAppLovinAdListener();
  }

  @override
  Future<void> show() async {
    // print('iron isAdLoaded show: $_isAdLoaded');

    if (!_isAdLoaded) return;
    if (adUnitType == AdUnitType.interstitial) {
      //  await normalScreen();
      final isCapped = await IronSource.isInterstitialPlacementCapped(
          placementName: adUnitId);
      final isReady = await IronSource.isInterstitialReady();
      // print('iron isReady: $isReady');
      // print('iron isCapped: $isCapped');
      if (!isCapped && isReady) {
        await IronSource.showInterstitial();
      }
    }
    _isAdLoaded = false;
  }

  // void _onAppLovinAdListener() {
  //   AppLovinMAX.setInterstitialListener(
  //     InterstitialListener(
  //       onAdLoadedCallback: (_) {
  //         _isAdLoaded = true;
  //         onAdLoaded?.call(adNetwork, adUnitType, null);
  //       },
  //       onAdLoadFailedCallback: (_, __) {
  //         _isAdLoaded = false;
  //         onAdFailedToLoad?.call(adNetwork, adUnitType, null,
  //             'Error occurred while loading $adNetwork ad');
  //       },
  //       onAdDisplayedCallback: (_) {
  //         onAdShowed?.call(adNetwork, adUnitType, null);
  //       },
  //       onAdDisplayFailedCallback: (_, __) {
  //         onAdFailedToShow?.call(adNetwork, adUnitType, null,
  //             'Error occurred while showing $adNetwork ad');
  //       },
  //       onAdClickedCallback: (_) {
  //         onAdClicked?.call(adNetwork, adUnitType, null);
  //       },
  //       onAdHiddenCallback: (_) {
  //         onAdDismissed?.call(adNetwork, adUnitType, null);
  //       },
  //     ),
  //   );
  // }
  //overrides intertitial ironSource.

  @override
  void onInterstitialAdReady() {
    _isAdLoaded = true;
    onAdLoaded?.call(adNetwork, adUnitType, null);
  }

  @override
  void onInterstitialAdLoadFailed(IronSourceError error) {
    _isAdLoaded = false;
    onAdFailedToLoad?.call(adNetwork, adUnitType, null,
        'Error occurred while loading $adNetwork ad');
  }

  @override
  void onInterstitialAdShowSucceeded() {
    onAdShowed?.call(adNetwork, adUnitType, null);
  }

  @override
  void onInterstitialAdShowFailed(IronSourceError error) {
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
