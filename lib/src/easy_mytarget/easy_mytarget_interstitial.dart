import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';

import 'package:my_target_flutter/my_target_flutter.dart';

class EasyMytargetInterstitialAd extends EasyAdBase {
  EasyMytargetInterstitialAd(String adUnitId, MyTargetFlutter? pluginParam)
      : super(adUnitId) {
    plugin = pluginParam;
  }

  MyTargetFlutter? plugin;
  bool _isAdLoaded = false;

  @override
  AdNetwork get adNetwork => AdNetwork.mytarget;

  @override
  AdUnitType get adUnitType => AdUnitType.interstitial;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  void dispose() => _isAdLoaded = false;

  InterstitialAd? interstitialAd;

  @override
  Future<void> load() async {
    // final _plugin = MyTargetFlutter(isDebug: true);
    // await plugin.initialize();
    interstitialAd?.clearListeners();
    interstitialAd =
        await plugin?.createInterstitialAd(int.parse(adUnitId)); //yourSlotId

    interstitialAd?.addListener(_listener);
    interstitialAd?.load();
  }

  AdStatusListener get _listener => AdStatusListener(
        onAdLoaded: () {
          _isAdLoaded = true;
          onAdLoaded?.call(adNetwork, adUnitType, 'Loaded');
        },
        onDisplay: () {
          onAdShowed?.call(adNetwork, adUnitType, null);
        },
        onClickOnAD: () {
          onAdClicked?.call(adNetwork, adUnitType, null);
        },
        onVideoCompleted: () {},
        onDismiss: () {
          onAdDismissed?.call(adNetwork, adUnitType, null);
          //load(); //carga el siguiente ok
        },
        onNoAd: (map) {
          _isAdLoaded = false;
          onAdFailedToLoad?.call(adNetwork, adUnitType, null,
              'Error occurred while loading $adNetwork ad');
        },
      );

  @override
  show() {
    if (!_isAdLoaded) return;
    interstitialAd?.show();
    _isAdLoaded = false;
  }
}
