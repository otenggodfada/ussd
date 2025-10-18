import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static bool _isInitialized = false;
  
  // AdMob App IDs (Replace with your actual IDs)
  static const String _androidAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const String _iosAppId = 'ca-app-pub-3940256099942544~1458002511';
  
  // Ad Unit IDs (Replace with your actual IDs)
  static const String _bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
    } catch (e) {
      // Handle initialization error
      print('AdMob initialization failed: $e');
    }
  }
  
  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );
  }
  
  static InterstitialAd? _interstitialAd;
  
  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }
  
  static void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          print('Interstitial ad showed full screen content');
        },
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          loadInterstitialAd(); // Load next ad
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          loadInterstitialAd(); // Load next ad
        },
      );
      _interstitialAd!.show();
    }
  }
  
  static RewardedAd? _rewardedAd;
  
  static void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Rewarded ad failed to load: $error');
        },
      ),
    );
  }
  
  static void showRewardedAd({required Function(RewardItem) onRewarded}) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          print('Rewarded ad showed full screen content');
        },
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedAd = null;
          loadRewardedAd(); // Load next ad
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _rewardedAd = null;
          loadRewardedAd(); // Load next ad
        },
      );
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        onRewarded(reward);
      });
    }
  }
}
