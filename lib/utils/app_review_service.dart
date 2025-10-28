import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage in-app review prompts with smart timing based on user engagement
class AppReviewService {
  // Keys for SharedPreferences
  static const String _sessionCountKey = 'app_session_count';
  static const String _lastReviewPromptKey = 'last_review_prompt_date';
  static const String _userRatedKey = 'user_has_rated';
  static const String _userDeclinedKey = 'user_declined_rating';
  static const String _lastActionTimestampKey = 'last_action_timestamp';
  static const String _actionCountKey = 'action_count';
  static const String _appInstallDateKey = 'app_install_date';
  static const String _lastRatingDeclineDateKey = 'last_rating_decline_date';

  // Configuration thresholds
  static const int _minSessionsBeforeReview = 5; // Minimum 5 app launches
  static const int _minDaysSinceInstall = 3; // At least 3 days since install
  static const int _daysBetweenPrompts = 30; // Don't ask again for 30 days if declined
  static const int _minActionsBeforeReview = 10; // User must have done at least 10 actions
  static const int _minMinutesInSession = 2; // User must be active for at least 2 minutes

  /// Initialize tracking on app first launch
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Track app install date if not already set
    if (!prefs.containsKey(_appInstallDateKey)) {
      await prefs.setInt(_appInstallDateKey, DateTime.now().millisecondsSinceEpoch);
    }
    
    // Increment session count on each launch
    final sessionCount = prefs.getInt(_sessionCountKey) ?? 0;
    await prefs.setInt(_sessionCountKey, sessionCount + 1);
  }

  /// Called when user performs a meaningful action in the app
  /// Returns true if we should request a review
  static Future<bool> shouldRequestReview() async {
    final prefs = await SharedPreferences.getInstance();

    // Don't ask if user already rated
    if (prefs.getBool(_userRatedKey) == true) {
      return false;
    }

    // Don't ask if user declined recently (within 30 days)
    final lastDeclineDate = prefs.getInt(_lastRatingDeclineDateKey);
    if (lastDeclineDate != null) {
      final daysSinceDecline = 
          DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(lastDeclineDate)).inDays;
      if (daysSinceDecline < _daysBetweenPrompts) {
        return false;
      }
    }

    // Get current values
    final sessionCount = prefs.getInt(_sessionCountKey) ?? 0;
    final lastActionTimestamp = prefs.getInt(_lastActionTimestampKey);
    final actionCount = prefs.getInt(_actionCountKey) ?? 0;
    final installDate = prefs.getInt(_appInstallDateKey);

    // Check if minimum time has passed since install
    if (installDate != null) {
      final daysSinceInstall = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(installDate))
          .inDays;
      if (daysSinceInstall < _minDaysSinceInstall) {
        return false;
      }
    }

    // Check if user has minimum sessions
    if (sessionCount < _minSessionsBeforeReview) {
      return false;
    }

    // Check if user has done minimum actions
    if (actionCount < _minActionsBeforeReview) {
      return false;
    }

    // Check if user has been active in this session (at least 2 minutes)
    if (lastActionTimestamp != null) {
      final minutesInSession = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(lastActionTimestamp))
          .inMinutes;
      if (minutesInSession < _minMinutesInSession && actionCount > 0) {
        return false; // Too early in session
      }
    }

    // Check when we last prompted for a review
    final lastPromptDate = prefs.getInt(_lastReviewPromptKey);
    if (lastPromptDate != null) {
      final daysSincePrompt = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(lastPromptDate))
          .inDays;
      // Don't ask too frequently (at least 7 days between prompts)
      if (daysSincePrompt < 7) {
        return false;
      }
    }

    return true;
  }

  /// Request a review (call this when you want to show the review dialog)
  static Future<void> requestReview({bool promptManually = false}) async {
    try {
      final InAppReview inAppReview = InAppReview.instance;
      
      // Check if review is available on this platform
      if (await inAppReview.isAvailable()) {
        // Update last prompt date
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_lastReviewPromptKey, DateTime.now().millisecondsSinceEpoch);

        if (promptManually) {
          // Show the system review dialog
          await inAppReview.requestReview();
        } else {
          // For in-app review, open the store page
          // This is more graceful and allows users to rate later
          await inAppReview.openStoreListing();
        }
      }
    } catch (e) {
      print('Error requesting review: $e');
    }
  }

  /// Call this when user successfully completes an action
  static Future<void> recordAction(String actionType, {String? metadata}) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Increment action count
    final actionCount = prefs.getInt(_actionCountKey) ?? 0;
    await prefs.setInt(_actionCountKey, actionCount + 1);
    
    // Update last action timestamp
    await prefs.setInt(_lastActionTimestampKey, DateTime.now().millisecondsSinceEpoch);
    
    print('📊 Action recorded: $actionType (Total: ${actionCount + 1})');
  }

  /// Mark that user has rated the app
  static Future<void> markAsRated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_userRatedKey, true);
    print('✅ User has rated the app');
  }

  /// Mark that user declined to rate
  static Future<void> markAsDeclined() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_userDeclinedKey, true);
    await prefs.setInt(_lastRatingDeclineDateKey, DateTime.now().millisecondsSinceEpoch);
    print('❌ User declined to rate');
  }

  /// Get current statistics
  static Future<Map<String, dynamic>> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    final installDate = prefs.getInt(_appInstallDateKey);
    
    int daysSinceInstall = 0;
    if (installDate != null) {
      daysSinceInstall = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(installDate))
          .inDays;
    }
    
    return {
      'sessionCount': prefs.getInt(_sessionCountKey) ?? 0,
      'actionCount': prefs.getInt(_actionCountKey) ?? 0,
      'daysSinceInstall': daysSinceInstall,
      'userRated': prefs.getBool(_userRatedKey) ?? false,
      'userDeclined': prefs.getBool(_userDeclinedKey) ?? false,
      'meetsCriteria': await shouldRequestReview(),
    };
  }

  /// Test method to manually trigger review (for testing/debugging)
  static Future<void> forceRequestReview() async {
    await requestReview(promptManually: true);
  }

  /// Reset all review data (for testing only)
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionCountKey);
    await prefs.remove(_lastReviewPromptKey);
    await prefs.remove(_userRatedKey);
    await prefs.remove(_userDeclinedKey);
    await prefs.remove(_lastActionTimestampKey);
    await prefs.remove(_actionCountKey);
    await prefs.remove(_appInstallDateKey);
    await prefs.remove(_lastRatingDeclineDateKey);
    print('🔄 Review service reset');
  }
}

