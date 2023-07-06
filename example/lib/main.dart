import 'dart:async';
import 'dart:io';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

// const IAdIdManager adIdManager = TestAdIdManager();
final adIdManager = MyIdManger();

class MyIdManger extends IAdIdManager {
  @override
  AppAdIds? get admobAdIds => null;
  /*
  AppAdIds(
        appId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544~3347511713'
            : 'ca-app-pub-3940256099942544~1458002511',
        appOpenId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/3419835294'
            : 'ca-app-pub-3940256099942544/5662855259',
        bannerId: 'ca-app-pub-3940256099942544/6300978111',
        interstitialId: 'ca-app-pub-3940256099942544/1033173712',
        rewardedId: 'ca-app-pub-3940256099942544/5224354917',
      );
   */

  @override
  AppAdIds? get fbAdIds =>
      null; /*const AppAdIds(
        appId: '1579706379118402',
        interstitialId: 'VID_HD_16_9_15S_LINK#YOUR_PLACEMENT_ID', //video test
        bannerId: 'IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID',
        rewardedId:
            'VID_HD_16_9_46S_APP_INSTALL#YOUR_PLACEMENT_ID', //video test
      );*/

  @override
  AppAdIds? get unityAdIds => AppAdIds(
        appId: Platform.isAndroid ? '4374881' : '4374880',
        bannerId: Platform.isAndroid ? 'Banner_Android' : 'Banner_iOS',
        interstitialId:
            Platform.isAndroid ? 'Interstitial_Android' : 'Interstitial_iOS',
        rewardedId: Platform.isAndroid ? 'Rewarded_Android' : 'Rewarded_iOS',
      );

  @override
  AppAdIds? get ironSourceAdIds => AppAdIds(
        appId: Platform.isAndroid ? '1889e3d75' : 'fe6d93e9',

        interstitialId:
            'DefaultInterstitial', // await IronSource.isInterstitialPlacementCapped(placementName: "Default")
        bannerId:
            'DefaultBanner', //IronSource.isBannerPlacementCapped('DefaultBanner')

        // rewardedId: 'DefaultRewardedVideo',
      );

  @override
  AppAdIds? get appLovinAdIds => AppAdIds(
        appId: "YOUR_SDK_KEY",
        bannerId: Platform.isAndroid
            ? 'ANDROID_BANNER_AD_UNIT_ID'
            : 'IOS_BANNER_AD_UNIT_ID',
        interstitialId: Platform.isAndroid
            ? 'ANDROID_INTER_AD_UNIT_ID'
            : 'IOS_INTER_AD_UNIT_ID',
        rewardedId: Platform.isAndroid
            ? 'ANDROID_REWARDED_AD_UNIT_ID'
            : 'IOS_REWARDED_AD_UNIT_ID',
      );

  @override
  AppAdIds? get yandexAdIds => AppAdIds(
        appId: '2460782',
        bannerId:
            Platform.isAndroid ? 'demo-banner-yandex' : 'IOS_BANNER_AD_UNIT_ID',
        interstitialId: Platform.isAndroid
            ? 'demo-interstitial-yandex'
            : 'IOS_INTER_AD_UNIT_ID',
      );

  @override
  AppAdIds? get vungleAdIds => const AppAdIds(
      appId: '6494f531cd4b24913c61c4b8', //'5adff6afb2cadf62871219ff'
      interstitialId: 'INTERSTITIALONE-8961105' //INTERSTITIALONE-8961105
      );

  @override
  AppAdIds? get mytargetAdIds => const AppAdIds(
        appId: 'cualquiera',
        interstitialId:
            '6896', //esta funcando con '6896' tomado del ejemplo , hasta que se apruebe en Mytarget// '1307283'
      );
  @override
  AppAdIds? get adColonyAdIds => const AppAdIds(
        appId: 'app8cb3ef4425934d0295',
        interstitialId: 'vze1e44a48128a4aaf8c',
      );

  @override
  AppAdIds? get startAppAdIds => const AppAdIds(
        appId:
            '201343194', //'201343194',//no es necesario aqui se define en AndroidManifest.xml
        interstitialId: '',
      );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyAds.instance.initialize(adIdManager,
      // adMobAdRequest: const AdRequest(),
      // admobConfiguration: RequestConfiguration(testDeviceIds: []),

      unityTestMode: true,
      fbTestingId: '73f92d66-f8f6-4978-999f-b5e0dd62275a',
      fbTestMode: true,
      enableLogger: true, //false in production
      // showAdBadge: Platform.isIOS,
      // fbiOSAdvertiserTrackingEnabled: true,

      //for intertitials priority/and enabled (solo los que se emnsionan se mostraran)
      priorityAdNetworks: [
        AdNetwork.vungle,
        AdNetwork.yandex,
        // AdNetwork.facebook,
        AdNetwork.ironSource,
        AdNetwork.unity,
        AdNetwork.appLovin,
        AdNetwork.mytarget,
        AdNetwork.adColony,
        AdNetwork.startApp,
        // AdNetwork.admob,
      ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Easy Ads Example',
      home: CountryListScreen(),
    );
  }
}

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({Key? key}) : super(key: key);

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  /// Using it to cancel the subscribed callbacks
  StreamSubscription? _streamSubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ad Network List"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'AppOpen',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              AdButton(
                networkName: 'Admob AppOpen',
                onTap: () => _showAd(AdNetwork.admob, AdUnitType.appOpen),
              ),
              const Divider(thickness: 2),
              Text(
                'Interstitial',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              AdButton(
                networkName: 'Admob Interstitial',
                onTap: () => _showAd(AdNetwork.admob, AdUnitType.interstitial),
              ),
              AdButton(
                networkName: 'Facebook Interstitial',
                onTap: () =>
                    _showAd(AdNetwork.facebook, AdUnitType.interstitial),
              ),
              AdButton(
                networkName: 'Unity Interstitial',
                onTap: () => _showAd(AdNetwork.unity, AdUnitType.interstitial),
              ),
              AdButton(
                networkName: 'Applovin Interstitial',
                onTap: () =>
                    _showAd(AdNetwork.appLovin, AdUnitType.interstitial),
              ),
              AdButton(
                networkName: 'IronSource Interstitial',
                onTap: () =>
                    _showAd(AdNetwork.ironSource, AdUnitType.interstitial),
              ),
              AdButton(
                networkName: 'Yandex Interstitial',
                onTap: () => _showAd(AdNetwork.yandex, AdUnitType.interstitial),
              ),
              AdButton(
                networkName: 'Vungle Interstitial',
                onTap: () => _showAd(AdNetwork.vungle, AdUnitType.interstitial),
              ),
              AdButton(
                networkName: 'myTarget Interstitial',
                onTap: () =>
                    _showAd(AdNetwork.mytarget, AdUnitType.interstitial),
              ),
              AdButton(
                networkName: 'AdColony Interstitial',
                onTap: () =>
                    _showAd(AdNetwork.adColony, AdUnitType.interstitial),
              ),
              AdButton(
                networkName: 'StartApp Interstitial',
                onTap: () =>
                    _showAd(AdNetwork.startApp, AdUnitType.interstitial),
              ),
              AdButton(
                networkName: 'Available Interstitial',
                onTap: () => _showAvailableAd(AdUnitType.interstitial),
              ),
              const Divider(thickness: 2),
              // Text(
              //   'Rewarded',
              //   style: Theme.of(context)
              //       .textTheme
              //       .headlineMedium!
              //       .copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
              // ),
              // AdButton(
              //   networkName: 'Admob Rewarded',
              //   onTap: () => _showAd(AdNetwork.admob, AdUnitType.rewarded),
              // ),
              // AdButton(
              //   networkName: 'Facebook Rewarded',
              //   onTap: () => _showAd(AdNetwork.facebook, AdUnitType.rewarded),
              // ),
              // AdButton(
              //   networkName: 'Unity Rewarded',
              //   onTap: () => _showAd(AdNetwork.unity, AdUnitType.rewarded),
              // ),
              // AdButton(
              //   networkName: 'Applovin Rewarded',
              //   onTap: () => _showAd(AdNetwork.appLovin, AdUnitType.rewarded),
              // ),
              // AdButton(
              //   networkName: 'IronSource Rewarded',
              //   onTap: () => _showAd(AdNetwork.ironSource, AdUnitType.rewarded),
              // ),
              // AdButton(
              //   networkName: 'Available Rewarded',
              //   onTap: () => _showAvailableAd(AdUnitType.rewarded),
              // ),
              const EasySmartBannerAd(
                priorityAdNetworks: [
                  //no hay vungle banner
                  AdNetwork.yandex,
                  AdNetwork.facebook,
                  AdNetwork.unity,
                  AdNetwork.ironSource,
                  // AdNetwork.appLovin,
                  // AdNetwork.admob,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAd(AdNetwork adNetwork, AdUnitType adUnitType) {
    if (EasyAds.instance.showAd(adUnitType,
        adNetwork: adNetwork,
        shouldShowLoader: Platform.isAndroid,
        context: context,
        delayInSeconds: 1)) {
      // Canceling the last callback subscribed
      _streamSubscription?.cancel();
      // Listening to the callback from showRewardedAd()
      _streamSubscription = EasyAds.instance.onEvent.listen((event) {
        if (event.adUnitType == adUnitType) {
          _streamSubscription?.cancel();
          goToNextScreen(adNetwork: adNetwork);
        }
      });
    } else {
      goToNextScreen(adNetwork: adNetwork);
    }
  }

  void _showAvailableAd(AdUnitType adUnitType) {
    if (EasyAds.instance.showAd(adUnitType)) {
      // Canceling the last callback subscribed
      _streamSubscription?.cancel();
      // Listening to the callback from showRewardedAd()
      _streamSubscription = EasyAds.instance.onEvent.listen((event) {
        if (event.adUnitType == adUnitType) {
          _streamSubscription?.cancel();
          goToNextScreen();
        }
      });
    } else {
      goToNextScreen();
    }
  }

  void goToNextScreen({AdNetwork? adNetwork}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryDetailScreen(adNetwork: adNetwork),
      ),
    );
  }
}

class CountryDetailScreen extends StatefulWidget {
  final AdNetwork? adNetwork;
  const CountryDetailScreen({Key? key, this.adNetwork}) : super(key: key);

  @override
  State<CountryDetailScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends State<CountryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('United States'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://cdn.britannica.com/33/4833-050-F6E415FE/Flag-United-States-of-America.jpg'),
              ),
            ),
          ),
          // (widget.adNetwork == null)
          //     ? const EasySmartBannerAd(
          //         priorityAdNetworks: [
          //           AdNetwork.yandex,

          //           AdNetwork.facebook,
          //           AdNetwork.unity,
          //           AdNetwork.ironSource,
          //           // AdNetwork.appLovin,
          //           // AdNetwork.admob,
          //         ],
          //       )
          //     : EasyBannerAd(
          //         adNetwork: widget.adNetwork!,
          //         adSize: AdSize.largeBanner,
          //       ),
          const Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'The U.S. is a country of 50 states covering a vast swath of North America, with Alaska in the northwest and Hawaii extending the nation’s presence into the Pacific Ocean. Major Atlantic Coast cities are New York, a global finance and culture center, and capital Washington, DC. Midwestern metropolis Chicago is known for influential architecture and on the west coast, Los Angeles\' Hollywood is famed for filmmaking',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdButton extends StatelessWidget {
  final String networkName;
  final VoidCallback onTap;
  const AdButton({Key? key, required this.onTap, required this.networkName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            networkName,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
          ),
        ),
      ),
    );
  }
}
