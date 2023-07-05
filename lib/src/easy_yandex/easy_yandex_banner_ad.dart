import 'dart:async';

import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:easy_ads_flutter/src/iron_source/easy_iron_source_banner.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import 'package:yandex_mobileads/mobile_ads.dart';
// import 'package:easy_audience_network/easy_audience_network.dart' hide BannerAd;

// import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;

class EasyYandexBannerAd extends EasyAdBase {
  final admob.AdSize? adSize;

  EasyYandexBannerAd(
    String adUnitId, {
    this.adSize = admob.AdSize.banner,
  }) : super(adUnitId);

  bool _isAdLoaded = false;

  @override
  AdUnitType get adUnitType => AdUnitType.banner;
  @override
  AdNetwork get adNetwork => AdNetwork.yandex;

  var adRequest = const AdRequest();

  @override
  void dispose() {}

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  Future<void> load() async {}

  final bannerProvider = BannerProvider();

  @override
  dynamic show() {
    // print('show banner yandex adUnitId-->${adUnitId}');
    final windowSize =
        WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;

    final bannerAd = BannerAd(
      adUnitId: adUnitId,
      adSize: AdSize.inline(
          width: windowSize.width.toInt(),
          maxHeight: kToolbarHeight.ceil() //windowSize.height ~/ 4,
          ),
      adRequest: adRequest,
      onAdLoaded: () {
        _isAdLoaded = true;
        onAdLoaded?.call(adNetwork, adUnitType, 'Loaded');
        onBannerAdReadyForSetState?.call(adNetwork, adUnitType, 'Loaded');
      },
      onAdFailedToLoad: (error) {
        _isAdLoaded = false;
        onAdFailedToLoad?.call(adNetwork, adUnitType, null,
            'Error occurred while loading banner ad: ${error.code}');
      },
    );
    return AdWidget(
      bannerAd: bannerAd,
    );

    // bannerAd?.load(adRequest: adRequest).then((_) {
    // _isLoad?.future.then((value) => bannerProvider.isBannerShow = true);
    // bannerProvider.isBannerShow = true;

    // return BuildBanner(
    //   adUnitId: adUnitId,
    //   bannerProvider: bannerProvider,
    //   bannerAd: bannerAd,
    // );
  }
}

// class BuildBanner extends StatelessWidget {
//   final BannerAd bannerAd;
//   final BannerProvider bannerProvider;
//   final String adUnitId;
//   const BuildBanner({
//     super.key,
//     required this.bannerAd,
//     required this.bannerProvider,
//     required this.adUnitId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (_) => bannerProvider,
//         ),
//       ],
//       child: Consumer<BannerProvider>(builder: (
//         context,
//         bannerProv,
//         child,
//       ) {
//         return bannerProv.isBannerShow //widget.bannerProvider
//             ? AdWidget(
//                 bannerAd: bannerAd,
//               )
//             : const SizedBox.shrink();
//       }),
//     );
//   }
// }
