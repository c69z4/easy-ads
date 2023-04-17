// import 'package:flutter/services.dart';
// import 'package:ironsource_mediation/ironsource_mediation.dart';

// class IronSourceInitializer extends IronSourceImpressionDataListener
//     with IronSourceInitializationListener {
//   final String appKey;
//   final String currentflutterVersion;
//   final String? interstitialAdUnitId;
//   final String? rewardedAdUnitId;

//   IronSourceInitializer({
//     required this.appKey,
//     required this.currentflutterVersion,
//     this.interstitialAdUnitId,
//     this.rewardedAdUnitId,
//   });

//   Future<void> enableDebug() async {
//     await IronSource.setAdaptersDebug(true);
//     // this function doesn't have to be awaited
//     IronSource.validateIntegration();
//   }

//   Future<void> setRegulationParams() async {
//     // GDPR
//     await IronSource.setConsent(true);
//     await IronSource.setMetaData({
//       // CCPA
//       'do_not_sell': ['false'],
//       // COPPA
//       'is_child_directed': ['false']
//     });
//     return;
//   }

//   Future<bool?> initIronSource() async {
//     // final appKey = Platform.isAndroid
//     //     ? "1889e3d75"
//     //     : Platform.isIOS
//     //         ? "fe6d93e9"
//     //         : throw Exception("Unsupported Platform");
//     try {
//       IronSource.setFlutterVersion(currentflutterVersion); //3.7.1 //2.8.1
//       IronSource.setImpressionDataListener(this);
//       await enableDebug();
//       await IronSource.shouldTrackNetworkState(true);

//       // GDPR, CCPA, COPPA etc
//       await setRegulationParams();

//       // Segment info
//       // await setSegment();

//       // For Offerwall
//       // Must be called before init
//       // await IronSource.setClientSideCallbacks(true);

//       // GAID, IDFA, IDFV
//       String id = await IronSource.getAdvertiserId();
//       print('AdvertiserID: $id');

//       // await IronSource.setUserId(_APP_USER_ID);//advance

//       // Authorization Request for IDFA use
//       // if (Platform.isIOS) {
//       //   await checkATT();
//       // }

//       //
//       // IronSource.setMetaData({
//       //   "Facebook_IS_CacheFlag": ["IMAGE"]
//       // });

//       // Finally, initialize

//       final adUnits = <IronSourceAdUnit>[];
//       if (interstitialAdUnitId != null) {
//         adUnits.add(IronSourceAdUnit.Interstitial);
//       }
//       if (rewardedAdUnitId != null) {
//         adUnits.add(IronSourceAdUnit.RewardedVideo);
//       }
//       await IronSource.init(
//         appKey: appKey,
//         adUnits: adUnits,
//         /*
//         [
//           // IronSourceAdUnit.RewardedVideo,
//           IronSourceAdUnit.Interstitial,
//           IronSourceAdUnit.Banner,
//           // IronSourceAdUnit.Offerwall
//         ]
//         */
//         initListener: this,
//       );
    

//       //listeners
//       // IronSource.setISListener(this);
//       return true;
//     } on PlatformException catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   @override
//   void onImpressionSuccess(IronSourceImpressionData? impressionData) {}

//   @override
//   void onInitializationComplete() {}
// }





// // import 'dart:async';
// // // import 'dart:io';
// // import 'package:flutter/services.dart';
// // import 'package:ironsource_mediation/ironsource_mediation.dart';

// // enum EventIron {
// //   clicked,
// //   closed,
// //   opened,
// //   showFailed,
// //   loadFailed,
// //   ready,
// //   showSucceeded,
// // }

// // class IronSourceSingleton
// //     with
// //         IronSourceImpressionDataListener,
// //         IronSourceInitializationListener,
// //         IronSourceInterstitialListener,
// //         IronSourceRewardedVideoManualListener {
// //   // singleton
// //   static final _ironSourceSingleton = IronSourceSingleton._internal();
// //   factory IronSourceSingleton() {
// //     return _ironSourceSingleton;
// //   }
// //   IronSourceSingleton._internal();
// //   //end singleton

// //   // final eventIron = Rx<EventIron?>(null);
// //   final eventItertitialIron = StreamController<EventIron?>();
// //   final eventRewardedIron = StreamController<EventIron?>();
// //   @override
// //   void onImpressionSuccess(IronSourceImpressionData? impressionData) {}

// //   @override
// //   void onInitializationComplete() {}

// //   Future<void> enableDebug() async {
// //     await IronSource.setAdaptersDebug(true);
// //     // this function doesn't have to be awaited
// //     IronSource.validateIntegration();
// //   }

// //   Future<void> setRegulationParams() async {
// //     // GDPR
// //     await IronSource.setConsent(true);
// //     await IronSource.setMetaData({
// //       // CCPA
// //       'do_not_sell': ['false'],
// //       // COPPA
// //       'is_child_directed': ['false']
// //     });
// //     return;
// //   }

// //   Future<bool?> initIronSource({
// //     required String appKey,
// //     required String currentflutterVersion,
// //     String? interstitialAdUnitId,
// //     String? rewardedAdUnitId,
// //   }) async {
// //     // final appKey = Platform.isAndroid
// //     //     ? "1889e3d75"
// //     //     : Platform.isIOS
// //     //         ? "fe6d93e9"
// //     //         : throw Exception("Unsupported Platform");
// //     try {
// //       IronSource.setFlutterVersion(currentflutterVersion); //3.7.1 //2.8.1
// //       IronSource.setImpressionDataListener(this);
// //       await enableDebug();
// //       await IronSource.shouldTrackNetworkState(true);

// //       // GDPR, CCPA, COPPA etc
// //       await setRegulationParams();

// //       // Segment info
// //       // await setSegment();

// //       // For Offerwall
// //       // Must be called before init
// //       // await IronSource.setClientSideCallbacks(true);

// //       // GAID, IDFA, IDFV
// //       String id = await IronSource.getAdvertiserId();
// //       print('AdvertiserID: $id');

// //       // await IronSource.setUserId(_APP_USER_ID);//advance

// //       // Authorization Request for IDFA use
// //       // if (Platform.isIOS) {
// //       //   await checkATT();
// //       // }

// //       //
// //       // IronSource.setMetaData({
// //       //   "Facebook_IS_CacheFlag": ["IMAGE"]
// //       // });

// //       // Finally, initialize

// //       final adUnits = <IronSourceAdUnit>[];
// //       if (interstitialAdUnitId != null) {
// //         adUnits.add(IronSourceAdUnit.Interstitial);
// //       }
// //       if (rewardedAdUnitId != null) {
// //         adUnits.add(IronSourceAdUnit.RewardedVideo);
// //       }
// //       await IronSource.init(
// //         appKey: appKey,
// //         adUnits: adUnits,
// //         /*
// //         [
// //           // IronSourceAdUnit.RewardedVideo,
// //           IronSourceAdUnit.Interstitial,
// //           IronSourceAdUnit.Banner,
// //           // IronSourceAdUnit.Offerwall
// //         ]
// //         */
// //         initListener: this,
// //       );

// //       //listeners
// //       IronSource.setISListener(this);
// //       return true;
// //     } on PlatformException catch (e) {
// //       print(e);
// //       return null;
// //     }
// //   }

// //   /// Invoked when an Interstitial ad became ready to be shown as a result of the precedent load function call.
// //   @override
// //   void onInterstitialAdReady() {
// //     // eventIron.value = EventIron.ready;
// //     eventItertitialIron.add(EventIron.ready);
// //     print('ready iron intertitial');
// //   }

// //   /// Invoked when there is no Interstitial ad available as a result of the precedent [loadInterstitial] call.
// //   /// - You can learn about the reason by examining [error]
// //   @override
// //   void onInterstitialAdLoadFailed(IronSourceError error) {
// //     // eventIron.value = EventIron.loadFailed;
// //     eventItertitialIron.add(EventIron.loadFailed);

// //     print('failed load iron--> intertitial');
// //   }

// //   /// Invoked when an Interstitial ad has opened
// //   @override
// //   void onInterstitialAdOpened() {
// //     // eventIron.value = EventIron.opened;
// //     eventItertitialIron.add(EventIron.opened);

// //     print('opened iron--> intertitial');
// //   }

// //   /// Invoked when the ad is closed and the user is about to return to the application.
// //   @override
// //   void onInterstitialAdClosed() {
// //     // eventIron.value = EventIron.closed;
// //     eventItertitialIron.add(EventIron.closed);

// //     print('closed iron--> intertitial');
// //   }

// //   /// Invoked when an Interstitial ad failed to show.
// //   /// - You can learn about the reason by examining [error]
// //   @override
// //   void onInterstitialAdShowFailed(IronSourceError error) {
// //     // eventIron.value = EventIron.showFailed;
// //     eventItertitialIron.add(EventIron.showFailed);

// //     print('showed failed iron--> intertitial $error');
// //   }

// //   /// Invoked when the end user clicked on the interstitial ad.
// //   /// - NOTE - This event is not supported by all the networks.
// //   @override
// //   void onInterstitialAdClicked() {
// //     // eventIron.value = EventIron.clicked;
// //     eventItertitialIron.add(EventIron.clicked);

// //     print('iron--> clicked');
// //   }

// //   /// Invoked when an Interstitial screen is about to open.
// //   /// - NOTE - This event is not supported by all the networks.
// //   /// - You should NOT treat this event as an interstitial impression,
// //   /// but rather use [onInterstitialAdOpened].
// //   @override
// //   void onInterstitialAdShowSucceeded() {
// //     print('iron--> ShowSucceeded');
// //     // eventIron.value = EventIron.showSucceeded;
// //     eventItertitialIron.add(EventIron.showSucceeded);
// //   }

// //   //rewarded
// //   @override
// //   void onRewardedVideoAdClicked(IronSourceRVPlacement placement) {
// //     eventRewardedIron.add(EventIron.clicked);
// //   }

// //   @override
// //   void onRewardedVideoAdClosed() {
// //     eventRewardedIron.add(EventIron.closed);
// //   }

// //   @override
// //   void onRewardedVideoAdLoadFailed(IronSourceError error) {
// //     eventRewardedIron.add(EventIron.loadFailed);
// //   }

// //   @override
// //   void onRewardedVideoAdOpened() {
// //     eventRewardedIron.add(EventIron.opened);
// //   }

// //   @override
// //   void onRewardedVideoAdReady() {
// //     eventRewardedIron.add(EventIron.ready);
// //   }

// //   @override
// //   void onRewardedVideoAdShowFailed(IronSourceError error) {
// //     eventRewardedIron.add(EventIron.showFailed);
// //   }

// //   @override
// //   void onRewardedVideoAdStarted() {
// //     eventRewardedIron.add(EventIron.showSucceeded);
// //   }
// // //not implement

// //   @override
// //   void onRewardedVideoAvailabilityChanged(bool isAvailable) {}

// //   @override
// //   void onRewardedVideoAdEnded() {}

// //   @override
// //   void onRewardedVideoAdRewarded(IronSourceRVPlacement placement) {}
// // }
