import 'dart:io';
// Conditionally import Google Mobile Ads only for non-simulator builds
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static bool _isInitialized = false;
  static int _interstitialAdCounter = 0;
  static int _interstitialAdFrequency = 3; // Show interstitial every 3 actions
  static bool _isSimulator = false;

  // Ad Unit IDs (Replace with your actual IDs)
  // Android Ad Unit IDs
  static const String _androidBannerAdUnitId =
      'ca-app-pub-8528924538237596/1234567890';
  static const String _androidInterstitialAdUnitId =
      'ca-app-pub-8528924538237596/3201256325';
  static const String _androidRewardedAdUnitId =
      'ca-app-pub-8528924538237596/1888174651';
  static const String _androidAppOpenAdUnitId =
      'ca-app-pub-8528924538237596/1278441198';

  // iOS Ad Unit IDs
  static const String _iosBannerAdUnitId =
      'ca-app-pub-8528924538237596/1234567894';
  static const String _iosInterstitialAdUnitId =
      'ca-app-pub-8528924538237596/9000377911';
  static const String _iosRewardedAdUnitId =
      'ca-app-pub-8528924538237596/7168421493';
  static const String _iosAppOpenAdUnitId =
      'ca-app-pub-8528924538237596/7687296243';

  // Helper methods to get platform-specific ad unit IDs
  static String get _bannerAdUnitId =>
      Platform.isIOS ? _iosBannerAdUnitId : _androidBannerAdUnitId;
  static String get _interstitialAdUnitId =>
      Platform.isIOS ? _iosInterstitialAdUnitId : _androidInterstitialAdUnitId;
  static String get _rewardedAdUnitId =>
      Platform.isIOS ? _iosRewardedAdUnitId : _androidRewardedAdUnitId;
  static String get _appOpenAdUnitId =>
      Platform.isIOS ? _iosAppOpenAdUnitId : _androidAppOpenAdUnitId;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Detect if running on simulator
      _isSimulator = await _isRunningOnSimulator();

      if (_isSimulator) {
        print(
            '🚫 AdMob skipped for iOS Simulator (MarketplaceKit not available)');
        _isInitialized = true;
        return;
      }

      // Initialize AdMob
      await MobileAds.instance.initialize();
      loadInterstitialAd();
      loadRewardedAd();
      loadAppOpenAd();
    } catch (e) {
      // Handle initialization error
      print('❌ AdMob initialization failed: $e');
      _isInitialized = true; // Mark as initialized to prevent retries
    }
  }

  static Future<bool> _isRunningOnSimulator() async {
    if (!Platform.isIOS) return false;

    try {
      // Check for simulator-specific characteristics
      return Platform.environment['SIMULATOR_DEVICE_NAME'] != null ||
          Platform.environment['SIMULATOR_ROOT'] != null;
    } catch (e) {
      // If detection fails, assume it's a physical device
      return false;
    }
  }

  static BannerAd? createBannerAd() {
    if (_isSimulator) {
      print('🚫 Banner ad creation skipped on simulator');
      return null;
    }

    return BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('✅ Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          print('❌ Banner ad failed to load: $error');
          ad.dispose();
        },
        onAdOpened: (ad) => print('✅ Banner ad opened'),
        onAdClosed: (ad) => print('✅ Banner ad closed'),
      ),
    );
  }

  static InterstitialAd? _interstitialAd;

  static void loadInterstitialAd() {
    if (_isSimulator) {
      print('🚫 Interstitial ad loading skipped on simulator');
      return;
    }

    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          print('✅ Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          print('❌ Interstitial ad failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  static void showInterstitialAd({bool force = false}) {
    if (_isSimulator) {
      print('🚫 Interstitial ad show skipped on simulator');
      return;
    }

    if (_interstitialAd == null) {
      print('❌ No interstitial ad available to show');
      loadInterstitialAd(); // Load a new ad for next time
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        print('✅ Interstitial ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (ad) {
        print('✅ Interstitial ad dismissed');
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd(); // Load a new ad for next time
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('❌ Interstitial ad failed to show: $error');
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd(); // Load a new ad for next time
      },
    );

    _interstitialAd!.show();
  }

  static void showInterstitialAdIfReady({bool force = false}) {
    if (force) {
      // Force show ad regardless of counter
      showInterstitialAd();
    } else {
      _interstitialAdCounter++;

      if (_interstitialAdCounter >= _interstitialAdFrequency) {
        _interstitialAdCounter = 0;
        showInterstitialAd();
      }
    }
  }

  static RewardedAd? _rewardedAd;

  static void loadRewardedAd() {
    if (_isSimulator) {
      print('🚫 Rewarded ad loading skipped on simulator');
      return;
    }

    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          print('✅ Rewarded ad loaded');
        },
        onAdFailedToLoad: (error) {
          print('❌ Rewarded ad failed to load: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  static void showRewardedAd({required Function(dynamic) onRewarded}) {
    if (_isSimulator) {
      print('🚫 Rewarded ad show skipped on simulator');
      // Call the reward callback anyway for testing
      onRewarded({'amount': 10, 'type': 'test'});
      return;
    }

    if (_rewardedAd == null) {
      print('❌ No rewarded ad available to show');
      loadRewardedAd(); // Load a new ad for next time
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        print('✅ Rewarded ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (ad) {
        print('✅ Rewarded ad dismissed');
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd(); // Load a new ad for next time
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('❌ Rewarded ad failed to show: $error');
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd(); // Load a new ad for next time
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      print('✅ User earned reward: ${reward.amount} ${reward.type}');
      onRewarded({'amount': reward.amount, 'type': reward.type});
    });
  }

  // App Open Ad
  static AppOpenAd? _appOpenAd;
  static bool _isShowingAd = false;

  static void loadAppOpenAd() {
    if (_isSimulator) {
      print('🚫 App open ad loading skipped on simulator');
      return;
    }

    AppOpenAd.load(
      adUnitId: _appOpenAdUnitId,
      request: const AdRequest(),
      orientation: AppOpenAd.orientationPortrait,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          print('✅ App open ad loaded');
        },
        onAdFailedToLoad: (error) {
          print('❌ App open ad failed to load: $error');
          _appOpenAd = null;
        },
      ),
    );
  }

  static void showAppOpenAdIfAvailable() {
    if (_isSimulator) {
      print('🚫 App open ad show skipped on simulator');
      return;
    }

    if (_appOpenAd == null || _isShowingAd) {
      print('❌ No app open ad available to show or already showing');
      return;
    }

    _isShowingAd = true;
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        print('✅ App open ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (ad) {
        print('✅ App open ad dismissed');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd(); // Load a new ad for next time
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('❌ App open ad failed to show: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd(); // Load a new ad for next time
      },
    );

    _appOpenAd!.show();
  }

  // Utility methods
  static void dispose() {
    _interstitialAd = null;
    _rewardedAd = null;
    _appOpenAd = null;
  }

  static bool get isInterstitialAdReady => _interstitialAd != null;
  static bool get isRewardedAdReady => _rewardedAd != null;
  static bool get isAppOpenAdReady => _appOpenAd != null;
  static bool get isSimulator => _isSimulator;

  // Navigation ad settings
  static int get navigationAdFrequency => _interstitialAdFrequency;
  static void setNavigationAdFrequency(int frequency) {
    _interstitialAdFrequency = frequency;
  }

  // Debug methods
  static void forceShowAppOpenAd() {
    if (_isSimulator) {
      print('🚫 Force show app open ad skipped on simulator');
      return;
    }

    showAppOpenAdIfAvailable();
  }
}
