import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static bool _isInitialized = false;
  static int _interstitialAdCounter = 0;
  static int _interstitialAdFrequency = 3; // Show interstitial every 3 actions
  
  // Ad Unit IDs (Replace with your actual IDs)
  // Android Ad Unit IDs
  static const String _androidBannerAdUnitId = 'ca-app-pub-8528924538237596/1234567890';
  static const String _androidInterstitialAdUnitId = 'ca-app-pub-8528924538237596/3201256325';
  static const String _androidRewardedAdUnitId = 'ca-app-pub-8528924538237596/1888174651';
  static const String _androidAppOpenAdUnitId = 'ca-app-pub-8528924538237596/1278441198';
  
  // iOS Ad Unit IDs
  static const String _iosBannerAdUnitId = 'ca-app-pub-8528924538237596/1234567894';
  static const String _iosInterstitialAdUnitId = 'ca-app-pub-8528924538237596/9000377911';
  static const String _iosRewardedAdUnitId = 'ca-app-pub-8528924538237596/7168421493';
  static const String _iosAppOpenAdUnitId = 'ca-app-pub-8528924538237596/7687296243';
  
  // Helper methods to get platform-specific ad unit IDs
  static String get _bannerAdUnitId => Platform.isIOS ? _iosBannerAdUnitId : _androidBannerAdUnitId;
  static String get _interstitialAdUnitId => Platform.isIOS ? _iosInterstitialAdUnitId : _androidInterstitialAdUnitId;
  static String get _rewardedAdUnitId => Platform.isIOS ? _iosRewardedAdUnitId : _androidRewardedAdUnitId;
  static String get _appOpenAdUnitId => Platform.isIOS ? _iosAppOpenAdUnitId : _androidAppOpenAdUnitId;
  
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      
      // Log platform and ad unit IDs being used
      print('AdMob initialized for ${Platform.isIOS ? 'iOS' : 'Android'}');
      print('Banner Ad Unit ID: $_bannerAdUnitId');
      print('Interstitial Ad Unit ID: $_interstitialAdUnitId');
      print('Rewarded Ad Unit ID: $_rewardedAdUnitId');
      print('App Open Ad Unit ID: $_appOpenAdUnitId');
      
      // Preload ads for better performance
      loadInterstitialAd();
      loadRewardedAd();
      loadAppOpenAd();
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
  
  static void showInterstitialAd({bool force = false}) {
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
        // Reward coins for watching ad
        _rewardCoinsForAd();
        onRewarded(reward);
      });
    }
  }

  static void _rewardCoinsForAd() {
    // Import and use CoinService to reward coins
    // This will be handled by the calling code
  }

  // App Open Ad
  static AppOpenAd? _appOpenAd;
  static bool _isShowingAd = false;

  static void loadAppOpenAd() {
    print('Loading app open ad with unit ID: $_appOpenAdUnitId');
    AppOpenAd.load(
      adUnitId: _appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print('✅ App open ad loaded successfully');
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('❌ App open ad failed to load: $error');
          _appOpenAd = null;
          // Retry loading after a delay
          Future.delayed(const Duration(seconds: 5), () {
            print('Retrying app open ad load...');
            loadAppOpenAd();
          });
        },
      ),
    );
  }

  static void showAppOpenAdIfAvailable() {
    print('showAppOpenAdIfAvailable called - Ad available: ${_appOpenAd != null}, Is showing: $_isShowingAd');
    
    if (_appOpenAd == null) {
      print('No app open ad available to show');
      return;
    }
    
    if (_isShowingAd) {
      print('App open ad is already being shown');
      return;
    }

    print('✅ Showing app open ad...');
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
        loadAppOpenAd(); // Load next ad
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('❌ App open ad failed to show: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd(); // Load next ad
      },
    );
    _appOpenAd!.show();
  }

  // Utility methods
  static void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _appOpenAd?.dispose();
    _interstitialAd = null;
    _rewardedAd = null;
    _appOpenAd = null;
  }

  static bool get isInterstitialAdReady => _interstitialAd != null;
  static bool get isRewardedAdReady => _rewardedAd != null;
  static bool get isAppOpenAdReady => _appOpenAd != null;
  
  // Navigation ad settings
  static int get navigationAdFrequency => _interstitialAdFrequency;
  static void setNavigationAdFrequency(int frequency) {
    _interstitialAdFrequency = frequency;
  }
  
  // Debug methods
  static void forceShowAppOpenAd() {
    print('Force showing app open ad...');
    if (_appOpenAd != null) {
      showAppOpenAdIfAvailable();
    } else {
      print('No app open ad available, loading one...');
      loadAppOpenAd();
      // Try to show after a delay
      Future.delayed(const Duration(seconds: 2), () {
        showAppOpenAdIfAvailable();
      });
    }
  }
}
