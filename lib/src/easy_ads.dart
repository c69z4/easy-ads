import 'dart:async';
// import 'dart:developer';

import 'package:applovin_max/applovin_max.dart';
import 'package:collection/collection.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:easy_ads_flutter/src/easy_admob/easy_admob_interstitial_ad.dart';
import 'package:easy_ads_flutter/src/easy_admob/easy_admob_rewarded_ad.dart';
import 'package:easy_ads_flutter/src/easy_applovin/easy_applovin_banner_ad.dart';
import 'package:easy_ads_flutter/src/easy_applovin/easy_applovin_interstitial_ad.dart';
import 'package:easy_ads_flutter/src/easy_applovin/easy_applovin_rewarded_ad.dart';
import 'package:easy_ads_flutter/src/easy_facebook/easy_facebook_banner_ad.dart';
import 'package:easy_ads_flutter/src/easy_facebook/easy_facebook_full_screen_ad.dart';
// import 'package:easy_ads_flutter/src/easy_unity/easy_unity_ad.dart';
import 'package:easy_ads_flutter/src/iron_source/easy_iron_source_banner.dart';
import 'package:easy_ads_flutter/src/utils/auto_hiding_loader_dialog.dart';
import 'package:easy_ads_flutter/src/utils/easy_event_controller.dart';
import 'package:easy_ads_flutter/src/utils/easy_logger.dart';
import 'package:easy_ads_flutter/src/utils/extensions.dart';
import 'package:easy_audience_network/easy_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ironsource_x/ironsource.dart';
// import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'iron_source/easy_iron_source_interstitial_ad.dart';

class EasyAds {
  EasyAds._easyAds();
  static final EasyAds instance = EasyAds._easyAds();

  /// Google admob's ad request
  AdRequest _adRequest = const AdRequest();
  late final IAdIdManager adIdManager;
  late AppLifecycleReactor _appLifecycleReactor;

  final _eventController = EasyEventController();
  Stream<AdEvent> get onEvent => _eventController.onEvent;

  List<EasyAdBase> get _allAds => [..._interstitialAds, ..._rewardedAds];

  /// All the interstitial ads will be stored in it
  final List<EasyAdBase> _appOpenAds = [];

  /// All the interstitial ads will be stored in it
  final List<EasyAdBase> _interstitialAds = [];

  final List<AdNetwork> _priorityAdNetworks = [];
  //  = const [
  //   AdNetwork.facebook,
  //   AdNetwork.ironSource,
  //   AdNetwork.unity,
  //   AdNetwork.appLovin,
  //   // AdNetwork.admob,
  // ];
  List<EasyAdBase> get _sortIntertitial {
    final result = <EasyAdBase>[];
    for (var priorityAdNetwork in _priorityAdNetworks) {
      final index =
          _interstitialAds.indexWhere((e) => e.adNetwork == priorityAdNetwork);
      if (index > -1) {
        result.add(_interstitialAds[index]);
      }
    }
    return result;
  }

  /// All the rewarded ads will be stored in it
  final List<EasyAdBase> _rewardedAds = [];

  /// [_logger] is used to show Ad logs in the console
  final EasyLogger _logger = EasyLogger();

  /// On banner, ad badge will appear
  bool get showAdBadge => _showAdBadge;
  bool _showAdBadge = false;

  /// Initializes the Google Mobile Ads SDK.
  ///
  /// Call this method as early as possible after the app launches
  /// [adMobAdRequest] will be used in all the admob requests. By default empty request will be used if nothing passed here.
  /// [fbTestingId] can be obtained by running the app once without the testingId.
  Future<void> initialize(IAdIdManager manager,
      {bool unityTestMode = false,
      bool fbTestMode = false,
      bool startAppTestMode = false,
      bool? isMutedAdmobIntertitial = false,
      AdRequest? adMobAdRequest,
      RequestConfiguration? admobConfiguration,
      bool enableLogger = true,
      String? fbTestingId,
      bool isAgeRestrictedUserForApplovin = false,
      bool fbiOSAdvertiserTrackingEnabled = false,
      int appOpenAdOrientation = AppOpenAd.orientationPortrait,
      bool showAdBadge = false,
      //iron source ini
      String? currentflutterVersion,
      //
      required List<AdNetwork> priorityAdNetworks}) async {
    _priorityAdNetworks.clear();
    _priorityAdNetworks.addAll(priorityAdNetworks);

// = const [
//     AdNetwork.facebook,
//     AdNetwork.ironSource,
//     AdNetwork.unity,
//     AdNetwork.appLovin,
//     // AdNetwork.admob,
//   ];

    _showAdBadge = showAdBadge;
    if (enableLogger) _logger.enable(enableLogger);
    adIdManager = manager;
    if (adMobAdRequest != null) {
      _adRequest = adMobAdRequest;
    }

    if (admobConfiguration != null) {
      MobileAds.instance.updateRequestConfiguration(admobConfiguration);
      if (isMutedAdmobIntertitial == true) {
        MobileAds.instance.setAppMuted(true);
      }
    }

    final fbAdId = manager.fbAdIds?.appId;
    if (fbAdId != null && fbAdId.isNotEmpty) {
      EasyAds.instance._initFacebook(
        testingId: fbTestingId,
        testMode: fbTestMode,
        iOSAdvertiserTrackingEnabled: fbiOSAdvertiserTrackingEnabled,
        interstitialPlacementId: manager.fbAdIds?.interstitialId,
        rewardedPlacementId: manager.fbAdIds?.rewardedId,
      );
    }

    //yandex init
    /*final yandexSdkId = manager.yandexAdIds?.appId;
    if (yandexSdkId != null && yandexSdkId.isNotEmpty) {
      EasyAds.instance._initYandex(
        sdkKey: yandexSdkId, //'2460782', no es necesario
        interstitialAdUnitId: manager.yandexAdIds?.interstitialId,
      );
    }*/
    //vungle init
    /*final vungleSdkId = manager.vungleAdIds?.appId;
    if (vungleSdkId != null && vungleSdkId.isNotEmpty) {
      EasyAds.instance._initVungle(
        
        sdkKey: vungleSdkId,
        interstitialAdUnitId: manager.vungleAdIds?.interstitialId,

        
      ); 
    }*/
    //mytarget init
    /*final mytargetSdkId = manager.mytargetAdIds?.appId;
    if (mytargetSdkId != null && mytargetSdkId.isNotEmpty) {
      EasyAds.instance._initMyTarget(
        sdkKey: mytargetSdkId,
        interstitialAdUnitId: manager.mytargetAdIds?.interstitialId,
        isDebug: false,
         
      );  
    }*/
    //adColony init

    // final adColonySdkId = manager.adColonyAdIds?.appId;
    // if (adColonySdkId != null && adColonySdkId.isNotEmpty) {
    //   EasyAds.instance._initAdColony(
    //     sdkKey: adColonySdkId,
    //     interstitialAdUnitId: manager.adColonyAdIds?.interstitialId,
    //     // rewardedAdUnitId: manager.appLovinAdIds?.rewardedId,
    //   ); // currentflutterVersion: currentflutterVersion
    // }
    // //startApp(startio) init

    // final startAppSdkId = manager.startAppAdIds?.appId;
    // if (startAppSdkId != null && startAppSdkId.isNotEmpty) {
    //   EasyAds.instance._initStartApp(
    //     testMode: startAppTestMode,
    //     // sdkKey: adColonySdkId,
    //     // interstitialAdUnitId: manager.adColonyAdIds?.interstitialId,
    //     // rewardedAdUnitId: manager.appLovinAdIds?.rewardedId,
    //   ); // currentflutterVersion: currentflutterVersion
    // }

    //iron source init
    final ironSourceSdkId = manager.ironSourceAdIds?.appId;
    if (ironSourceSdkId != null && ironSourceSdkId.isNotEmpty) {
      EasyAds.instance._initIronSource(
        // keywords: adMobAdRequest?.keywords,
        // isAgeRestrictedUser: isAgeRestrictedUserForApplovin,
        sdkKey: ironSourceSdkId,
        interstitialAdUnitId: manager.ironSourceAdIds?.interstitialId,

        // rewardedAdUnitId: manager.appLovinAdIds?.rewardedId,
      ); // currentflutterVersion: currentflutterVersion
    }

    /*final unityGameId = manager.unityAdIds?.appId;
    if (unityGameId != null && unityGameId.isNotEmpty) {
      EasyAds.instance._initUnity(
        unityGameId: unityGameId,
        testMode: unityTestMode,
        interstitialPlacementId: manager.unityAdIds?.interstitialId,
        rewardedPlacementId: manager.unityAdIds?.rewardedId,
      );
    }*/

    final appLovinSdkId = manager.appLovinAdIds?.appId;
    if (appLovinSdkId != null && appLovinSdkId.isNotEmpty) {
      EasyAds.instance._initAppLovin(
        sdkKey: appLovinSdkId,
        keywords: adMobAdRequest?.keywords,
        isAgeRestrictedUser: isAgeRestrictedUserForApplovin,
        interstitialAdUnitId: manager.appLovinAdIds?.interstitialId,
        rewardedAdUnitId: manager.appLovinAdIds?.rewardedId,
      );
    }

    final admobAdId = manager.admobAdIds?.appId;
    if (admobAdId != null && admobAdId.isNotEmpty) {
      final response = await MobileAds.instance.initialize();
      final status = response.adapterStatuses.values.firstOrNull?.state;

      _eventController.fireNetworkInitializedEvent(
          AdNetwork.admob, status == AdapterInitializationState.ready);

      // Initializing admob Ads
      await EasyAds.instance._initAdmob(
        appOpenAdUnitId: manager.admobAdIds?.appOpenId,
        interstitialAdUnitId: manager.admobAdIds?.interstitialId,
        rewardedAdUnitId: manager.admobAdIds?.rewardedId,
        appOpenAdOrientation: appOpenAdOrientation,
      );
    }
  }

  /// Returns [EasyAdBase] if ad is created successfully. It assumes that you have already assigned banner id in Ad Id Manager
  ///
  /// if [adNetwork] is provided, only that network's ad would be created. For now, only unity and admob banner is supported
  /// [adSize] is used to provide ad banner size
  EasyAdBase? createBanner(
      {required AdNetwork adNetwork, AdSize adSize = AdSize.banner}) {
    EasyAdBase? ad;

    switch (adNetwork) {
      case AdNetwork.admob:
        final bannerId = adIdManager.admobAdIds?.bannerId;
        // assert(bannerId != null,
        //     'You are trying to create a banner and Admob Banner id is null in ad id manager');
        if (bannerId != null) {
          ad = EasyAdmobBannerAd(bannerId,
              adSize: adSize, adRequest: _adRequest);
          _eventController.setupEvents(ad);
        }
        break;

      // case AdNetwork.unity:
      //   final bannerId = adIdManager.unityAdIds?.bannerId;
      //   // assert(bannerId != null,
      //   //     'You are trying to create a banner and Unity Banner id is null in ad id manager');
      //   if (bannerId != null) {
      //     ad = EasyUnityBannerAd(bannerId, adSize: adSize);
      //     _eventController.setupEvents(ad);
      //   }
      //   break;

      case AdNetwork.facebook:
        final bannerId = adIdManager.fbAdIds?.bannerId;
        // assert(bannerId != null,
        //     'You are trying to create a banner and Facebook Banner id is null in ad id manager');
        if (bannerId != null) {
          ad = EasyFacebookBannerAd(bannerId, adSize: adSize);
          _eventController.setupEvents(ad);
        }
        break;
      case AdNetwork.appLovin:
        final bannerId = adIdManager.appLovinAdIds?.bannerId;
        // assert(bannerId != null,
        //     'You are trying to create a banner and Applovin Banner id is null in ad id manager');
        if (bannerId != null) {
          ad = EasyApplovinBannerAd(bannerId, adSize: adSize);
          _eventController.setupEvents(ad);
        }
        break;

      case AdNetwork.ironSource:
        final bannerId = adIdManager.ironSourceAdIds?.bannerId;
        // assert(bannerId != null,
        //     'You are trying to create a banner and ironSource Banner id is null in ad id manager');
        if (bannerId != null) {
          ad = EasyIronSourceBannerAd(bannerId, adSize: adSize);
          _eventController.setupEvents(ad);
        }
        break;
      //NO OLVIDAR AGREGAR AQUI LOS NUEVOS BANNER DE NUEVAS REDES DE ANUNCIOS(BANNER).
      /*case AdNetwork.yandex:
        final bannerId = adIdManager.yandexAdIds?.bannerId;
       
        if (bannerId != null) {
          ad = EasyYandexBannerAd(bannerId);
          _eventController.setupEvents(ad);
        }
        break;*/

      // case AdNetwork.startApp:
      //   final bannerId = adIdManager.startAppAdIds?.bannerId;
      //   if (bannerId != null) {
      //     ad = EasyStartAppBannerAd(bannerId, adSize: adSize);
      //     _eventController.setupEvents(ad);
      //   }
      //   break;

      default:
        ad = null;
    }
    return ad;
  }

  Future<void> _initAdmob({
    String? appOpenAdUnitId,
    String? interstitialAdUnitId,
    String? rewardedAdUnitId,
    bool immersiveModeEnabled = true,
    int appOpenAdOrientation = AppOpenAd.orientationPortrait,
  }) async {
    // init interstitial ads
    if (interstitialAdUnitId != null &&
        _interstitialAds.doesNotContain(
            AdNetwork.admob, AdUnitType.interstitial)) {
      final ad = EasyAdmobInterstitialAd(
          interstitialAdUnitId, _adRequest, immersiveModeEnabled);
      // log('Admob--->${ad.adNetwork.name}');
      _interstitialAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
    }

    // init rewarded ads
    if (rewardedAdUnitId != null &&
        _rewardedAds.doesNotContain(AdNetwork.admob, AdUnitType.rewarded)) {
      final ad = EasyAdmobRewardedAd(
          rewardedAdUnitId, _adRequest, immersiveModeEnabled);
      _rewardedAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
    }

    if (appOpenAdUnitId != null &&
        _appOpenAds.doesNotContain(AdNetwork.admob, AdUnitType.appOpen)) {
      final appOpenAdManager =
          EasyAdmobAppOpenAd(appOpenAdUnitId, _adRequest, appOpenAdOrientation);
      await appOpenAdManager.load();
      _appLifecycleReactor =
          AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
      _appLifecycleReactor.listenToAppStateChanges();
      _appOpenAds.add(appOpenAdManager);
      _eventController.setupEvents(appOpenAdManager);
    }
  }

  Future<void> _initAppLovin({
    required String sdkKey,
    bool? isAgeRestrictedUser,
    String? interstitialAdUnitId,
    String? rewardedAdUnitId,
    List<String>? keywords,
  }) async {
    final response = await AppLovinMAX.initialize(sdkKey);

    AppLovinMAX.targetingData.maximumAdContentRating =
        isAgeRestrictedUser == true
            ? AdContentRating.allAudiences
            : AdContentRating.none;

    if (keywords != null) {
      AppLovinMAX.targetingData.keywords = keywords;
    }

    if (response != null) {
      _eventController.fireNetworkInitializedEvent(AdNetwork.appLovin, true);
    } else {
      _eventController.fireNetworkInitializedEvent(AdNetwork.appLovin, false);
    }

    // init interstitial ads
    if (interstitialAdUnitId != null &&
        _interstitialAds.doesNotContain(
            AdNetwork.appLovin, AdUnitType.interstitial)) {
      final ad = EasyApplovinInterstitialAd(interstitialAdUnitId);
      // log('AppLovin--->${ad.adNetwork.name}');
      _interstitialAds.add(ad);

      _eventController.setupEvents(ad);

      await ad.load();
    }

    // init rewarded ads
    if (rewardedAdUnitId != null &&
        _rewardedAds.doesNotContain(AdNetwork.appLovin, AdUnitType.rewarded)) {
      final ad = EasyApplovinRewardedAd(rewardedAdUnitId);
      _rewardedAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
    }
  }

  /*Future<void> _initYandex({
    required String sdkKey,
 
    String? interstitialAdUnitId,
  }) async {
 
    if (interstitialAdUnitId != null &&
        _interstitialAds.doesNotContain(
            AdNetwork.yandex, AdUnitType.interstitial)) {
      final ad = EasyYandexInterstitialAd(interstitialAdUnitId);
      _interstitialAds.add(ad);
      log('yandex--->${ad.adNetwork.name}');

      _eventController.setupEvents(ad);

      await ad.load();
    }
  }*/

  /*Future<void> _initVungle({
    required String sdkKey,
    // bool? isAgeRestrictedUser,
    String? interstitialAdUnitId,
  }) async {
    Vungle.init(sdkKey);
    Vungle.onInitilizeListener = () async {
      if (interstitialAdUnitId != null &&
          _interstitialAds.doesNotContain(
              AdNetwork.vungle, AdUnitType.interstitial)) {
        final ad = EasyVungleInterstitialAd(interstitialAdUnitId);

        Vungle.onAdPlayableListener = (placementId, playable) {
          if (playable) {
            ad.isAdLoaded = true;
            ad.onAdLoaded?.call(ad.adNetwork, ad.adUnitType, null);
          } else {
            ad.onAdFailedToLoad?.call(ad.adNetwork, ad.adUnitType, null,
                'Error occurred while loading ${ad.adNetwork} ad');
            ad.isAdLoaded = false;
          }
        };

        Vungle.onAdEndListener = (p) {
          ad.onAdDismissed?.call(ad.adNetwork, ad.adUnitType, null);
          //  load(); //carga el siguiente ok
        };
        // log('Vungle--->${ad.adNetwork.name}');
        _interstitialAds.add(ad);
        _eventController.setupEvents(ad);
        await ad.load();
      }
    };
     
  }*/

  /*Future<void> _initMyTarget(
      {required String sdkKey,
      String? interstitialAdUnitId,
      isDebug = true}) async {
    final plugin = MyTargetFlutter(isDebug: isDebug);
    await plugin.initialize();
    if (interstitialAdUnitId != null &&
        _interstitialAds.doesNotContain(
            AdNetwork.mytarget, AdUnitType.interstitial)) {
      final ad = EasyMytargetInterstitialAd(interstitialAdUnitId, plugin);

      log('MyTarget--->${ad.adNetwork.name}');
      _interstitialAds.add(ad);
      _eventController.setupEvents(ad);
      await ad.load();
    }
  }*/

  // Future<void> _initAdColony({
  //   required String sdkKey,
  //   String? interstitialAdUnitId,
  // }) async {
  //   await AdColony.init(AdColonyOptions(sdkKey, '0', [interstitialAdUnitId!]));

  //   if (_interstitialAds.doesNotContain(
  //       AdNetwork.adColony, AdUnitType.interstitial)) {
  //     final ad = EasyAdColonyInterstitialAd(interstitialAdUnitId);

  //     // log('AdColony--->${ad.adNetwork.name}');

  //     _interstitialAds.add(ad);
  //     _eventController.setupEvents(ad);
  //     await ad.load();
  //   }
  // }

  // Future<void> _initStartApp({required bool testMode}) async {
  //   final startAppSdk = StartAppSdk();

  //   if (testMode) {
  //     await startAppSdk.setTestAdsEnabled(true);
  //   }

  //   final isNoContains = _interstitialAds.doesNotContain(
  //       AdNetwork.startApp, AdUnitType.interstitial);
  //   if (isNoContains) {
  //     final ad = EasyStartAppInterstitialAd('', startAppSdk);
  //     _interstitialAds.add(ad);
  //     // log('StartApp--->${ad.adNetwork.name}');

  //     _eventController.setupEvents(ad);
  //     await ad.load();
  //   }

  //   // log('adstotal-->${_interstitialAds.map((e) => e.adNetwork.name).toList()}');
  // }

  /// * [unityGameId] - identifier from Project Settings in Unity Dashboard.
  /// * [testMode] - if true, then test ads are shown.
  /*Future _initUnity({
    String? unityGameId,
    bool testMode = false,
    String? interstitialPlacementId,
    String? rewardedPlacementId,
  }) async {
    // placementId
    if (unityGameId != null) {
      await UnityAds.init(
        gameId: unityGameId,
        testMode: testMode,
        onComplete: () =>
            _eventController.fireNetworkInitializedEvent(AdNetwork.unity, true),
        onFailed: (UnityAdsInitializationError error, String s) =>
            _eventController.fireNetworkInitializedEvent(
                AdNetwork.unity, false),
      );
    }

    // init interstitial ads
    if (interstitialPlacementId != null &&
        _interstitialAds.doesNotContain(
            AdNetwork.unity, AdUnitType.interstitial)) {
      final ad = EasyUnityAd(interstitialPlacementId, AdUnitType.interstitial);
      // log('Facebook--->${ad.adNetwork.name}');

      _interstitialAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
    }

    // init rewarded ads
    if (rewardedPlacementId != null &&
        _rewardedAds.doesNotContain(AdNetwork.unity, AdUnitType.rewarded)) {
      final ad = EasyUnityAd(rewardedPlacementId, AdUnitType.rewarded);
      _rewardedAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
    }
  }*/

  Future _initFacebook({
    required bool iOSAdvertiserTrackingEnabled,
    required bool testMode,
    String? testingId,
    String? interstitialPlacementId,
    String? rewardedPlacementId,
  }) async {
    final status = await EasyAudienceNetwork.init(
        testingId: testingId,
        testMode: testMode,
        iOSAdvertiserTrackingEnabled: iOSAdvertiserTrackingEnabled);

    _eventController.fireNetworkInitializedEvent(
        AdNetwork.facebook, status ?? false);

    // init interstitial ads
    if (interstitialPlacementId != null &&
        _interstitialAds.doesNotContain(
            AdNetwork.facebook, AdUnitType.interstitial)) {
      final ad = EasyFacebookFullScreenAd(
          interstitialPlacementId, AdUnitType.interstitial);

      // log('Facebook--->${ad.adNetwork.name}');

      _interstitialAds.add(ad);
      // _interstitialAds.insert(
      //     0, ad); //tradar que facebook siempre sea el primero(ok, funca)

      _eventController.setupEvents(ad);

      await ad.load();
    }

    // init rewarded ads
    if (rewardedPlacementId != null &&
        _rewardedAds.doesNotContain(AdNetwork.facebook, AdUnitType.rewarded)) {
      final ad =
          EasyFacebookFullScreenAd(rewardedPlacementId, AdUnitType.rewarded);
      _rewardedAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
    }
  }

//Ironsource init

  Future<void> _initIronSource({
    required String sdkKey,
    // bool? isAgeRestrictedUser,
    // List<String>? keywords,
    String? interstitialAdUnitId,
    // String? rewardedAdUnitId,
    //  String? currentflutterVersion
  }) async {
    bool? response;

    var userId = await IronSource.getAdvertiserId();
    await IronSource.validateIntegration();
    await IronSource.setUserId(userId);

    if (interstitialAdUnitId != null) {
      final intertitialIronSource =
          EasyIronSourceInterstitialAd(interstitialAdUnitId);

      response = await IronSource.initialize(
        appKey: sdkKey,
        listener: intertitialIronSource,
        gdprConsent: true,
        ccpaConsent: true,
        isChildDirected: false,
      );

      // print('response iron source $response');

      if (response != null) {
        _eventController.fireNetworkInitializedEvent(
            AdNetwork.ironSource, true);
      } else {
        _eventController.fireNetworkInitializedEvent(
            AdNetwork.ironSource, false);
      }

      // init interstitial ads
      if (_interstitialAds.doesNotContain(
          AdNetwork.ironSource, AdUnitType.interstitial)) {
        final ad = intertitialIronSource;
        // IronSource.setISListener(ad);

        // log('IronSource--->${ad.adNetwork.name}');

        _interstitialAds.add(ad);
        _eventController.setupEvents(ad);
        await ad.load();
      }
    }

    // interstitialReady = await IronSource.isInterstitialReady();
    // rewardeVideoAvailable = await IronSource.isRewardedVideoAvailable();
    // offerwallAvailable = await IronSource.isOfferwallAvailable();

    // try {
    // IronSource.setFlutterVersion(
    //     currentflutterVersion ?? '3.10.0-5.0.pre.15');
    // //debug
    // await IronSource.setAdaptersDebug(true);
    // IronSource.validateIntegration();
    // //set regulation params
    // // GDPR
    // await IronSource.setConsent(true);
    // await IronSource.setMetaData({
    //   // CCPA
    //   'do_not_sell': ['false'],
    //   // COPPA
    //   'is_child_directed': ['false']
    // });

    // // GAID, IDFA, IDFV
    // String id = await IronSource.getAdvertiserId();
    // print('AdvertiserID: $id');

    // final adUnits = <IronSourceAdUnit>[];
    // if (interstitialAdUnitId != null) {
    //   adUnits.add(IronSourceAdUnit.Interstitial);
    // }
    // if (rewardedAdUnitId != null) {
    //   adUnits.add(IronSourceAdUnit.RewardedVideo);
    // }
    // await IronSource.init(
    //   appKey: sdkKey,
    //   adUnits: adUnits,
    //   // initListener: this,
    // );

    //   response = true;
    // } catch (e) {
    //   response = null;
    // }

    // init rewarded ads
    // if (rewardedAdUnitId != null &&
    //     _rewardedAds.doesNotContain(
    //         AdNetwork.ironSource, AdUnitType.rewarded)) {
    //   final ad = EasyIronSourceRewarded(rewardedAdUnitId);
    //   IronSource.setRVListener(ad);
    //   _rewardedAds.add(ad);
    //   _eventController.setupEvents(ad);

    //   await ad.load();
    // }
  }

  /// Displays [adUnitType] ad from [adNetwork]. It will check if first ad it found from list is loaded,
  /// it will be displayed if [adNetwork] is not mentioned otherwise it will load the ad.
  ///
  /// Returns bool indicating whether ad has been successfully displayed or not
  ///
  /// [adUnitType] should be mentioned here, only interstitial or rewarded should be mentioned here
  /// if [adNetwork] is provided, only that network's ad would be displayed
  /// if [shouldShowLoader] before interstitial. If it's true, you have to provide build context.
  bool showAd(AdUnitType adUnitType,
      {AdNetwork adNetwork = AdNetwork.any,
      bool shouldShowLoader = false,
      int delayInSeconds = 2,
      BuildContext? context}) {
    List<EasyAdBase> ads = [];
    if (adUnitType == AdUnitType.rewarded) {
      ads = _rewardedAds;
    } else if (adUnitType == AdUnitType.interstitial) {
      // ads = _interstitialAds;
      ads = _sortIntertitial; //ok
      // print('_interstitialAds length--->${ads.length}');
    } else if (adUnitType == AdUnitType.appOpen) {
      ads = _appOpenAds;
    }
    // log('ads-->${ads.map((e) => e.adNetwork.name)}');
    if (adNetwork != AdNetwork.any) {
      // var ad = ads.firstWhereOrNull(
      //     (e) => AdNetwork.facebook == e.adNetwork); //primero facebook
      final ad = ads.firstWhereOrNull((e) => adNetwork == e.adNetwork);
      if (ad?.isAdLoaded == true) {
        if (ad?.adUnitType == AdUnitType.interstitial &&
            shouldShowLoader &&
            context != null) {
          showLoaderDialog(context, delay: delayInSeconds)
              .then((_) => ad?.show());
        } else {
          ad?.show();
        }
        return true;
      } else {
        _logger.logInfo(
            '${ad?.adNetwork} ${ad?.adUnitType} was not loaded, so called loading');
        ad?.load();
        return false;
      }
    }

    for (final ad in ads) {
      // log('ad-->${ad.adNetwork.name}-->${ad.isAdLoaded}');
      if (ad.isAdLoaded) {
        if (adNetwork == AdNetwork.any || adNetwork == ad.adNetwork) {
          if (ad.adUnitType == AdUnitType.interstitial &&
              shouldShowLoader &&
              context != null) {
            showLoaderDialog(context, delay: delayInSeconds)
                .then((_) => ad.show());
          } else {
            ad.show();
          }
          return true;
        }
      } else {
        _logger.logInfo(
            '${ad.adNetwork} ${ad.adUnitType} was not loaded, so called loading');
        ad.load();
      }
    }

    return false;
  }

  /// This will load both rewarded and interstitial ads.
  /// If a particular ad is already loaded, it will not load it again.
  /// Also you do not have to call this method everytime. Ad is automatically loaded after being displayed.
  ///
  /// if [adNetwork] is provided, only that network's ad would be loaded
  void loadAd({AdNetwork adNetwork = AdNetwork.any}) {
    for (final e in _rewardedAds) {
      if (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) {
        e.load();
      }
    }

    for (final e in _interstitialAds) {
      if (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) {
        e.load();
      }
    }
  }

  /// Returns bool indicating whether ad has been loaded
  ///
  /// if [adNetwork] is provided, only that network's ad would be checked
  bool isRewardedAdLoaded({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = _rewardedAds.firstWhereOrNull((e) =>
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
        e.isAdLoaded);
    return ad?.isAdLoaded ?? false;
  }

  /// Returns bool indicating whether ad has been loaded
  ///
  /// if [adNetwork] is provided, only that network's ad would be checked
  bool isInterstitialAdLoaded({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = _interstitialAds.firstWhereOrNull((e) =>
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
        e.isAdLoaded);
    return ad?.isAdLoaded ?? false;
  }

  /// Do not call this method until unless you want to remove ads entirely from the app.
  /// Best user case for this method could be removeAds In app purchase.
  ///
  /// After this, ads would stop loading. You would have to call initialize again.
  ///
  /// if [adNetwork] is provided only that network's ads will be disposed otherwise it will be ignored
  /// if [adUnitType] is provided only that ad unit type will be disposed, otherwise it will be ignored
  void destroyAds(
      {AdNetwork adNetwork = AdNetwork.any, AdUnitType? adUnitType}) {
    for (final e in _allAds) {
      if ((adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
          (adUnitType == null || adUnitType == e.adUnitType)) {
        e.dispose();
      }
    }
  }

  // @override
  // void onInitializationComplete() {
  //   print('ironsource onInitializationComplete');
  // }
}
