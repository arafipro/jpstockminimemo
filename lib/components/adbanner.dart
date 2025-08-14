import "package:jpstockminimemo/constants/imports.dart";

// 参考サイト
// https://uedive.net/2021/5410/flutter2-gad/

class AdBanner extends StatelessWidget {
  AdBanner({
    super.key,
  });

  final BannerAd myBanner = BannerAd(
    //TEST ANDROID : ca-app-pub-3940256099942544/6300978111
    //TEST IOS : ca-app-pub-3940256099942544/2934735716
    adUnitId: Platform.isAndroid
        ? dotenv.get("ANDROID_UNIT_ID")
        : dotenv.get("IOS_UNIT_ID"),
    size: AdSize.fullBanner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) => debugPrint("バナー広告がロードされました"),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        debugPrint("バナー広告の読み込みが次の理由で失敗しました: $error");
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => debugPrint("バナー広告が開かれました"),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => debugPrint("バナー広告が閉じられました"),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => debugPrint("Ad impression."),
    ),
  );

  @override
  Widget build(BuildContext context) {
    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);
    return Container(
      alignment: Alignment.center,
      width: View.of(context).physicalSize.width,
      height: myBanner.size.height.toDouble(),
      child: adWidget,
    );
  }
}
