import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ironsource_x/banner.dart';
import 'package:provider/provider.dart';

class EasyIronSourceBannerAd extends EasyAdBase with IronSourceBannerListener {
  EasyIronSourceBannerAd(String adUnitId) : super(adUnitId);

  @override
  AdUnitType get adUnitType => AdUnitType.banner;
  @override
  AdNetwork get adNetwork => AdNetwork.ironSource;

  @override
  void dispose() {}

  @override
  bool get isAdLoaded => false;

  @override
  Future<void> load() async {}

  @override
  dynamic show() {
    // print('show banner');
    final bannerProvider = BannerProvider();
    final bannerWidget = BuildBanner(
      easyIronSourceBannerAd: this,
      bannerProvider: bannerProvider,
      adUnitId: adUnitId,
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      bannerProvider.isBannerShow = true;
    });
    return bannerWidget;
  }

  @override
  void onBannerAdClicked() {
    onAdClicked?.call(adNetwork, adUnitType, null);
  }

  @override
  void onBannerAdLeftApplication() {}

  @override
  void onBannerAdLoadFailed(Map<String, dynamic> error) {
    onAdFailedToLoad?.call(adNetwork, adUnitType, null,
        'Error occurred while loading $adNetwork ad with ${error.toString()}');
  }

  @override
  void onBannerAdLoaded() {
    onAdLoaded?.call(adNetwork, adUnitType, null);
    onBannerAdReadyForSetState?.call(adNetwork, adUnitType, null);
  }

  @override
  void onBannerAdScreenDismissed() {}

  @override
  void onBannerAdScreenPresented() {
    onAdShowed?.call(adNetwork, adUnitType, null);
  }
}

class BuildBanner extends StatelessWidget {
  final EasyIronSourceBannerAd easyIronSourceBannerAd;
  final BannerProvider bannerProvider;
  final String adUnitId;
  const BuildBanner({
    super.key,
    required this.easyIronSourceBannerAd,
    required this.bannerProvider,
    required this.adUnitId,
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
        // print('reload Consumer Align osea Banner');

        /*
        banner
        largeBanner
        mediumRectangle
        fullBanner
        leaderboard
        fluid
        
         */
        // final sizeBanner =

        return bannerProv.isBannerShow //widget.bannerProvider
            ? Align(
                alignment: Alignment.bottomCenter,
                child: IronSourceBannerAd(
                  keepAlive: true,
                  listener: easyIronSourceBannerAd,
                  size: BannerSize.BANNER,
                  placementName: adUnitId,
                  // size: BannerSize.LARGE,
                  // size: BannerSize.LEADERBOARD,
                  // size: BannerSize.RECTANGLE,
                  // size: BannerSize.SMART,
                  /* size: BannerSize(
                            type: BannerSizeType.BANNER,
                            width: 400,
                            height: 50,
                          ), */
                  // backgroundColor: Colors.amber,
                ),
              )
            : const SizedBox.shrink();
      }),
    );
  }
}

class BannerProvider extends ChangeNotifier {
  bool _isBannerShow = false;
  bool get isBannerShow => _isBannerShow;
  set isBannerShow(bool value) {
    _isBannerShow = value;
    notifyListeners();
  }
}
