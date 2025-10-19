import 'package:shared_preferences/shared_preferences.dart';

enum PremiumFeature {
  removeAdsWeek,
  removeAdsMonth,
  showAllSMSWeek,
  removeFavoritesWeek,
  showAllCodesWeek,
}

class PremiumFeaturesService {
  static const String _prefix = 'premium_feature_';
  
  // Check if a premium feature is active
  static Future<bool> isFeatureActive(PremiumFeature feature) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix${feature.name}';
    final expiryTimestamp = prefs.getInt(key);
    
    if (expiryTimestamp == null) return false;
    
    final now = DateTime.now().millisecondsSinceEpoch;
    final isActive = now < expiryTimestamp;
    
    // Clean up expired features
    if (!isActive) {
      await prefs.remove(key);
    }
    
    return isActive;
  }

  // Activate a premium feature for specified duration
  static Future<bool> activateFeature(PremiumFeature feature, Duration duration) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix${feature.name}';
    final expiryTimestamp = DateTime.now().add(duration).millisecondsSinceEpoch;
    
    await prefs.setInt(key, expiryTimestamp);
    print('Activated ${feature.name} until ${DateTime.fromMillisecondsSinceEpoch(expiryTimestamp)}');
    return true;
  }

  // Get feature expiry time
  static Future<DateTime?> getFeatureExpiry(PremiumFeature feature) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix${feature.name}';
    final expiryTimestamp = prefs.getInt(key);
    
    if (expiryTimestamp == null) return null;
    
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now >= expiryTimestamp) {
      // Feature expired, clean up
      await prefs.remove(key);
      return null;
    }
    
    return DateTime.fromMillisecondsSinceEpoch(expiryTimestamp);
  }

  // Get remaining time for a feature
  static Future<Duration?> getFeatureRemainingTime(PremiumFeature feature) async {
    final expiry = await getFeatureExpiry(feature);
    if (expiry == null) return null;
    
    return expiry.difference(DateTime.now());
  }

  // Format remaining time as string
  static Future<String> getFeatureRemainingTimeString(PremiumFeature feature) async {
    final remaining = await getFeatureRemainingTime(feature);
    if (remaining == null) return 'Not active';
    
    if (remaining.inDays > 0) {
      return '${remaining.inDays}d ${remaining.inHours % 24}h';
    } else if (remaining.inHours > 0) {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m';
    } else {
      return '${remaining.inMinutes}m';
    }
  }

  // Get all active features
  static Future<List<PremiumFeature>> getActiveFeatures() async {
    final activeFeatures = <PremiumFeature>[];
    
    for (final feature in PremiumFeature.values) {
      if (await isFeatureActive(feature)) {
        activeFeatures.add(feature);
      }
    }
    
    return activeFeatures;
  }

  // Deactivate a feature
  static Future<void> deactivateFeature(PremiumFeature feature) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix${feature.name}';
    await prefs.remove(key);
    print('Deactivated ${feature.name}');
  }

  // Deactivate all features
  static Future<void> deactivateAllFeatures() async {
    final prefs = await SharedPreferences.getInstance();
    
    for (final feature in PremiumFeature.values) {
      final key = '$_prefix${feature.name}';
      await prefs.remove(key);
    }
    
    print('Deactivated all premium features');
  }

  // Get feature display info
  static Map<PremiumFeature, Map<String, dynamic>> getFeatureInfo() {
    return {
      PremiumFeature.removeAdsWeek: {
        'name': 'Remove Ads (1 Week)',
        'description': 'Enjoy ad-free experience for 1 week',
        'duration': Duration(days: 7),
        'icon': '🚫',
      },
      PremiumFeature.removeAdsMonth: {
        'name': 'Remove Ads (1 Month)',
        'description': 'Enjoy ad-free experience for 1 month',
        'duration': Duration(days: 30),
        'icon': '🚫',
      },
      PremiumFeature.showAllSMSWeek: {
        'name': 'Show All SMS (1 Week)',
        'description': 'View unlimited SMS insights for 1 week',
        'duration': Duration(days: 7),
        'icon': '📱',
      },
      PremiumFeature.removeFavoritesWeek: {
        'name': 'Remove from Favorites (1 Week)',
        'description': 'Remove codes from favorites without ads for 1 week',
        'duration': Duration(days: 7),
        'icon': '❤️',
      },
      PremiumFeature.showAllCodesWeek: {
        'name': 'Show All Codes (1 Week)',
        'description': 'View unlimited USSD codes for 1 week',
        'duration': Duration(days: 7),
        'icon': '📞',
      },
    };
  }

  // Check if user has any active premium features
  static Future<bool> hasAnyActiveFeature() async {
    final activeFeatures = await getActiveFeatures();
    return activeFeatures.isNotEmpty;
  }

  // Get premium status summary
  static Future<Map<String, dynamic>> getPremiumStatus() async {
    final activeFeatures = await getActiveFeatures();
    final status = <String, dynamic>{};
    
    for (final feature in PremiumFeature.values) {
      final info = getFeatureInfo()[feature]!;
      final isActive = await isFeatureActive(feature);
      final remainingTime = await getFeatureRemainingTimeString(feature);
      
      status[feature.name] = {
        'name': info['name'],
        'description': info['description'],
        'icon': info['icon'],
        'is_active': isActive,
        'remaining_time': remainingTime,
      };
    }
    
    return {
      'has_premium': activeFeatures.isNotEmpty,
      'active_features_count': activeFeatures.length,
      'features': status,
    };
  }
}
