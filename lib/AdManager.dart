import 'dart:io';

class AdManager {

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7458814027439195/8136124943";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }


}