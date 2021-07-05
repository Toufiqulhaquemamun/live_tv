import 'dart:io';
class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5984576530658152~5284364158";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8820429648092875~6939684035";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5984576530658152/3830029291";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8820429648092875/6748112346";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8820429648092875/5984559541";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8820429648092875/1495785666";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/8673189370";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/7552160883";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}