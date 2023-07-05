abstract class IAdIdManager {
  const IAdIdManager();

  /// Pass null if you wish not to implement unity ads
  ///
  /// AppAdIds? get unityAdIds => null;
  AppAdIds? get unityAdIds;

  /// Pass null if you wish not to implement admob ads
  ///
  /// AppAdIds? get admobAdIds => null;
  AppAdIds? get admobAdIds;

  /// Pass null if you wish not to implement appLovin ads
  ///
  /// AppAdIds? get appLovinAdIds => null;
  AppAdIds? get appLovinAdIds;

  /// Pass null if you wish not to implement facebook ads
  ///
  /// AppAdIds? get fbAdIds => null;
  AppAdIds? get fbAdIds;

  /// Pass null if you wish not to implement IronSource ads
  ///
  /// AppAdIds? get ironSourceAdIds => null;
  AppAdIds? get ironSourceAdIds;

  /// AppAdIds? get yandexAdIds => null;
  AppAdIds? get yandexAdIds;

  /// AppAdIds? get vungleAdIds => null;
  AppAdIds? get vungleAdIds;

  /// AppAdIds? get mytargetAdIds => null;
  AppAdIds? get mytargetAdIds;

  /// AppAdIds? get adColonyAdIds => null;
  AppAdIds? get adColonyAdIds;

  /// AppAdIds? get startAppAdIds => null;
  AppAdIds? get startAppAdIds;
}

class AppAdIds {
  /// App Id should never be null, if there is no app id for a particular ad network, leave it empty
  final String appId;

  /// if id is null, it will not be implemented
  final String? appOpenId;

  /// if id is null, it will not be implemented
  final String? interstitialId;

  /// if id is null, it will not be implemented
  final String? rewardedId;

  /// if id is null, it will not be implemented
  final String? bannerId;

  const AppAdIds({
    required this.appId,
    this.appOpenId,
    this.interstitialId,
    this.rewardedId,
    this.bannerId,
  });
}
