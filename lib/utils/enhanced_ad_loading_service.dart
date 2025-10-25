import 'package:flutter/material.dart';
import 'package:ussd_plus/utils/admob_service.dart';
import 'package:ussd_plus/widgets/loading_dialog.dart';

class EnhancedAdLoadingService {
  static const int _defaultTimeoutSeconds = 15;
  static const int _progressUpdateIntervalMs = 500;

  /// Shows a rewarded ad with enhanced loading feedback and timeout handling
  static Future<bool> showRewardedAdWithFeedback({
    required BuildContext context,
    required Function(dynamic) onRewarded,
    int timeoutSeconds = _defaultTimeoutSeconds,
    String? customLoadingMessage,
    String? customSubtitle,
  }) async {
    // Check if ad is already ready
    if (AdMobService.isRewardedAdReady) {
      // Ad is ready, show it directly without loading dialog
      _showRewardedAdDirectly(onRewarded);
      return true;
    }

    // Check if we're on simulator - handle differently
    if (AdMobService.isSimulator) {
      // On simulator, show ad immediately without loading dialog
      _showRewardedAdDirectly(onRewarded);
      return true;
    }

    // Show enhanced loading dialog
    if (context.mounted) {
      LoadingDialog.showWithProgress(
        context,
        customLoadingMessage ?? 'Loading Advertisement',
        subtitle:
            customSubtitle ?? 'Please wait while we prepare your reward...',
        progress: 0.0,
      );
    }

    // Set up loading state callbacks
    String currentLoadingState = 'Initializing...';
    double currentProgress = 0.0;
    bool adLoaded = false;
    bool timeoutReached = false;

    // Set up callbacks
    AdMobService.setLoadingStateCallback((state) {
      currentLoadingState = state;
      if (context.mounted && !timeoutReached) {
        LoadingDialog.showWithProgress(
          context,
          state,
          subtitle:
              customSubtitle ?? 'Please wait while we prepare your reward...',
          progress: currentProgress,
        );
      }
    });

    AdMobService.setLoadingProgressCallback((progress) {
      currentProgress = progress;
      if (context.mounted && !timeoutReached) {
        LoadingDialog.showWithProgress(
          context,
          currentLoadingState,
          subtitle:
              customSubtitle ?? 'Please wait while we prepare your reward...',
          progress: progress,
        );
      }
    });

    // Start loading rewarded ads
    AdMobService.loadRewardedAd();

    // Wait for ad to load with progress updates and timeout
    final startTime = DateTime.now();
    final timeoutDuration = Duration(seconds: timeoutSeconds);

    while (!adLoaded && !timeoutReached) {
      await Future.delayed(
        const Duration(milliseconds: _progressUpdateIntervalMs),
      );

      final elapsed = DateTime.now().difference(startTime);

      if (elapsed >= timeoutDuration) {
        timeoutReached = true;
        break;
      }

      // Update progress based on time elapsed
      final timeProgress =
          elapsed.inMilliseconds / timeoutDuration.inMilliseconds;
      if (context.mounted && !timeoutReached) {
        LoadingDialog.showWithProgress(
          context,
          currentLoadingState,
          subtitle:
              customSubtitle ?? 'Please wait while we prepare your reward...',
          progress: timeProgress,
        );
      }

      // Check if ad is ready
      if (AdMobService.isRewardedAdReady) {
        adLoaded = true;
        break;
      }
    }

    // Clear callbacks
    AdMobService.setLoadingStateCallback((_) {});
    AdMobService.setLoadingProgressCallback((_) {});

    // Hide loading dialog
    if (context.mounted) {
      LoadingDialog.hide(context);
    }

    if (adLoaded && context.mounted) {
      // Ad loaded successfully, show it
      _showRewardedAdDirectly(onRewarded);
      return true;
    } else {
      // Timeout or failure - show fallback message
      if (context.mounted) {
        _showTimeoutFallback(context, timeoutReached);
      }
      return false;
    }
  }

  /// Shows a rewarded ad directly without loading feedback
  static void _showRewardedAdDirectly(Function(dynamic) onRewarded) {
    AdMobService.showRewardedAd(onRewarded: onRewarded);
  }

  /// Shows timeout fallback message
  static void _showTimeoutFallback(BuildContext context, bool timeoutReached) {
    final message = timeoutReached
        ? 'Advertisement loading timed out. Proceeding without ad...'
        : 'Advertisement unavailable. Proceeding without ad...';

    final backgroundColor = timeoutReached ? Colors.orange : Colors.red;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () {
            // Retry loading ads
            AdMobService.loadRewardedAd();
          },
        ),
      ),
    );
  }

  /// Preloads rewarded ads in the background
  static void preloadRewardedAds() {
    if (!AdMobService.isRewardedAdReady && !AdMobService.isLoadingRewardedAd) {
      AdMobService.loadRewardedAd();
    }
  }

  /// Checks if ads are ready and preloads if needed
  static void ensureAdsReady() {
    if (!AdMobService.isRewardedAdReady) {
      preloadRewardedAds();
    }
  }

  /// Gets the current ad loading status
  static Map<String, dynamic> getAdStatus() {
    return {
      'isRewardedAdReady': AdMobService.isRewardedAdReady,
      'isLoadingRewardedAd': AdMobService.isLoadingRewardedAd,
      'isInterstitialAdReady': AdMobService.isInterstitialAdReady,
      'isLoadingInterstitialAd': AdMobService.isLoadingInterstitialAd,
      'isAppOpenAdReady': AdMobService.isAppOpenAdReady,
      'isLoadingAppOpenAd': AdMobService.isLoadingAppOpenAd,
      'isSimulator': AdMobService.isSimulator,
    };
  }
}
