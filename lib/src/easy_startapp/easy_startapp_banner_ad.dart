import 'dart:async';

import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:easy_ads_flutter/src/iron_source/easy_iron_source_banner.dart';
import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;
import 'package:provider/provider.dart';
import 'package:startapp_sdk/startapp.dart';

class EasyStartAppBannerAd extends EasyAdBase {
  final admob.AdSize? adSize;

  EasyStartAppBannerAd(
    String adUnitId, {
    this.adSize = admob.AdSize.banner,
  }) : super(adUnitId);

  bool _isAdLoaded = false;

  @override
  AdUnitType get adUnitType => AdUnitType.banner;
  @override
  AdNetwork get adNetwork => AdNetwork.startApp;

  @override
  void dispose() {}

  @override
  bool get isAdLoaded => _isAdLoaded;
  final startAppSdk = StartAppSdk();
  StartAppBannerAd? _bannerAd;
  final bannerProvider = BannerProvider();
  @override
  Future<void> load() async {
    // _bannerAd?.dispose();
    // print('adSize-->${adSize?.height}');
    startAppSdk
        .loadBannerAd(adSize == admob.AdSize.banner
            ? StartAppBannerType.BANNER
            : StartAppBannerType.MREC)
        .then((bannerAd) {
          _bannerAd = bannerAd;
          _isAdLoaded = true;
          // print('Loaded StartAppBannerAd');
          onAdLoaded?.call(adNetwork, adUnitType, 'Loaded');
          onBannerAdReadyForSetState?.call(adNetwork, adUnitType, 'Loaded');
        })
        .onError<StartAppException>((ex, stackTrace) {})
        .onError((error, stackTrace) {
          _isAdLoaded = false;
          onAdFailedToLoad?.call(adNetwork, adUnitType, null,
              'Error occurred while loading banner ad: $error');
        });
  }

  @override
  dynamic show() {
    if (_bannerAd != null) {
      final bannerWidget = BuildBanner(
        bannerProvider: bannerProvider,
        bannerAd: _bannerAd!,
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        bannerProvider.isBannerShow = true;
      });
      return bannerWidget;
    }
  }
}

class BuildBanner extends StatelessWidget {
  final StartAppBannerAd bannerAd;
  final BannerProvider bannerProvider;

  const BuildBanner({
    super.key,
    required this.bannerAd,
    required this.bannerProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => bannerProvider,
        ),
      ],
      child: Consumer<BannerProvider>(builder: (
        context,
        bannerProv,
        child,
      ) {
        return bannerProv.isBannerShow //widget.bannerProvider
            ? StartAppBanner(bannerAd)
            : const SizedBox.shrink();
      }),
    );
  }
}
