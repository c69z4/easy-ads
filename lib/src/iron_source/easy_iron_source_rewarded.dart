// import 'package:easy_ads_flutter/src/easy_ad_base.dart';
// import 'package:easy_ads_flutter/src/enums/ad_network.dart';
// import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
// import 'package:ironsource_mediation/ironsource_mediation.dart';

// class EasyIronSourceRewarded extends EasyAdBase
//     with IronSourceRewardedVideoManualListener {
//   EasyIronSourceRewarded(
//     String adUnitId,
//   ) : super(adUnitId);

//   bool _isAdLoaded = false;

//   @override
//   AdNetwork get adNetwork => AdNetwork.ironSource;

//   @override
//   AdUnitType get adUnitType => AdUnitType.rewarded;

//   @override
//   bool get isAdLoaded => _isAdLoaded;

//   @override
//   void dispose() => _isAdLoaded = false;

//   @override
//   Future<void> load() async {
//     if (_isAdLoaded) return;
//     if (adUnitType == AdUnitType.rewarded) {
//       await IronSource.loadRewardedVideo();
//       // AppLovinMAX.loadInterstitial(adUnitId);
//       // _isAdLoaded = await AppLovinMAX.isInterstitialReady(adUnitId) ?? false;
//     }
//     // _onAppLovinAdListener();
//   }

//   @override
//   Future<void> show() async {
//     if (!_isAdLoaded) return;
//     if (adUnitType == AdUnitType.rewarded) {
//       //  await normalScreen();
//       final isCapped = await IronSource.isRewardedVideoPlacementCapped(
//           placementName: adUnitId);
//       final isAvailable = await IronSource.isRewardedVideoAvailable();
//       if (!isCapped && isAvailable) {
//         await IronSource.showRewardedVideo();
//       }
//     }
//     _isAdLoaded = false;
//   }

//   // void _onAppLovinAdListener() {
//   //   AppLovinMAX.setInterstitialListener(
//   //     InterstitialListener(
//   //       onAdLoadedCallback: (_) {
//   //         _isAdLoaded = true;
//   //         onAdLoaded?.call(adNetwork, adUnitType, null);
//   //       },
//   //       onAdLoadFailedCallback: (_, __) {
//   //         _isAdLoaded = false;
//   //         onAdFailedToLoad?.call(adNetwork, adUnitType, null,
//   //             'Error occurred while loading $adNetwork ad');
//   //       },
//   //       onAdDisplayedCallback: (_) {
//   //         onAdShowed?.call(adNetwork, adUnitType, null);
//   //       },
//   //       onAdDisplayFailedCallback: (_, __) {
//   //         onAdFailedToShow?.call(adNetwork, adUnitType, null,
//   //             'Error occurred while showing $adNetwork ad');
//   //       },
//   //       onAdClickedCallback: (_) {
//   //         onAdClicked?.call(adNetwork, adUnitType, null);
//   //       },
//   //       onAdHiddenCallback: (_) {
//   //         onAdDismissed?.call(adNetwork, adUnitType, null);
//   //       },
//   //     ),
//   //   );
//   // }

//   //overrides rewarded ironSource.
//   @override
//   void onRewardedVideoAdReady() {
//     _isAdLoaded = true;
//     onAdLoaded?.call(adNetwork, adUnitType, null);
//   }

//   @override
//   void onRewardedVideoAdLoadFailed(IronSourceError error) {
//     _isAdLoaded = false;
//     onAdFailedToLoad?.call(adNetwork, adUnitType, null,
//         'Error occurred while loading $adNetwork ad');
//   }

//   @override
//   void onRewardedVideoAdOpened() {
//     onAdShowed?.call(adNetwork, adUnitType, null);
//   }

//   @override
//   void onRewardedVideoAdShowFailed(IronSourceError error) {
//     onAdFailedToShow?.call(adNetwork, adUnitType, null,
//         'Error occurred while showing $adNetwork ad');
//   }

//   @override
//   void onRewardedVideoAdClicked(IronSourceRVPlacement placement) {
//     onAdClicked?.call(adNetwork, adUnitType, null);
//   }

//   @override
//   void onRewardedVideoAdClosed() {
//     onAdDismissed?.call(adNetwork, adUnitType, null);
//   }

//   @override
//   void onRewardedVideoAdEnded() {}

//   @override
//   void onRewardedVideoAdRewarded(IronSourceRVPlacement placement) {}

//   @override
//   void onRewardedVideoAdStarted() {}

//   @override
//   void onRewardedVideoAvailabilityChanged(bool isAvailable) {}
// }
