// import 'package:easy_ads_flutter/src/easy_ad_base.dart';
// import 'package:easy_ads_flutter/src/enums/ad_network.dart';
// import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
// import 'package:vungle/vungle.dart';

// class EasyVungleInterstitialAd extends EasyAdBase {
//   EasyVungleInterstitialAd(
//     String adUnitId,
//   ) : super(adUnitId);

//   bool _isAdLoaded = false;

//   @override
//   AdNetwork get adNetwork => AdNetwork.vungle;

//   @override
//   AdUnitType get adUnitType => AdUnitType.interstitial;

//   @override
//   bool get isAdLoaded => _isAdLoaded;
//   set isAdLoaded(bool value) => _isAdLoaded = value;

//   @override
//   void dispose() => _isAdLoaded = false;
//   // var adRequest = const AdRequest();
//   // InterstitialAd? interstitialAd;

//   @override
//   Future<void> load() async {
//     Vungle.loadAd(adUnitId);

//     // To know if the ad loaded
//     // Vungle.onAdPlayableListener = (placementId, playable) {
//     //   if (playable) {
//     //     _isAdLoaded = true;
//     //     onAdLoaded?.call(adNetwork, adUnitType, null);
//     //   } else {
//     //     onAdFailedToLoad?.call(adNetwork, adUnitType, null,
//     //         'Error occurred while loading $adNetwork ad');
//     //     _isAdLoaded = false;
//     //   }
//     // };

//     // interstitialAd = await InterstitialAd.create(
//     //   adUnitId: adUnitId,
//     //   onAdLoaded: () {
//     //     _isAdLoaded = true;
//     //     onAdLoaded?.call(adNetwork, adUnitType, 'Loaded');
//     //   },
//     //   onAdFailedToLoad: (error) {
//     //     _isAdLoaded = false;
//     //     onAdFailedToLoad?.call(adNetwork, adUnitType, null,
//     //         'Error occurred while loading ${error.code}');
//     //   },
//     // );
//     // await interstitialAd?.load(adRequest: adRequest);

//     // // if (_isAdLoaded) return;
//     // // if (adUnitType == AdUnitType.interstitial) {
//     // //   await interstitialAd?.load(adRequest: adRequest);
//     // // }
//   }

//   @override
//   show() {
//     if (!_isAdLoaded) return;

//     Vungle.playAd(adUnitId);

//     // Deprecated. Please use OnAdEndListener
//     // Vungle.onAdEndListener = (p) {
//     //   onAdDismissed?.call(adNetwork, adUnitType, null);
//     //   //  load(); //carga el siguiente ok
//     // };

//     // interstitialAd?.show().then((_) {
//     //   interstitialAd?.waitForDismiss().then((value) {
//     //     onAdDismissed?.call(adNetwork, adUnitType, null);
//     //     load(); //carga el siguiente ok
//     //   });
//     // });

//     _isAdLoaded = false;
//   }
// }
