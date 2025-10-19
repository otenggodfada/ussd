import 'package:shared_preferences/shared_preferences.dart';

class CoinService {
  static const String _coinsKey = 'user_coins';
  static const String _totalCoinsEarnedKey = 'total_coins_earned';
  
  // Coin rewards
  static const int _rewardedAdCoins = 10;
  static const int _interstitialAdCoins = 5;
  
  // Premium feature costs
  static const int _removeAdsWeekCost = 50;
  static const int _removeAdsMonthCost = 180;
  static const int _showAllSMSWeekCost = 30;
  static const int _removeFavoritesWeekCost = 25;
  static const int _showAllCodesWeekCost = 35;

  // Get current coin balance
  static Future<int> getCoinBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_coinsKey) ?? 0;
  }

  // Add coins to user balance
  static Future<int> addCoins(int amount, String source) async {
    final prefs = await SharedPreferences.getInstance();
    final currentCoins = await getCoinBalance();
    final newBalance = currentCoins + amount;
    
    await prefs.setInt(_coinsKey, newBalance);
    
    // Track total coins earned
    final totalEarned = prefs.getInt(_totalCoinsEarnedKey) ?? 0;
    await prefs.setInt(_totalCoinsEarnedKey, totalEarned + amount);
    
    print('Added $amount coins from $source. New balance: $newBalance');
    return newBalance;
  }

  // Spend coins (returns true if successful)
  static Future<bool> spendCoins(int amount, String feature) async {
    final currentCoins = await getCoinBalance();
    
    if (currentCoins >= amount) {
      final prefs = await SharedPreferences.getInstance();
      final newBalance = currentCoins - amount;
      await prefs.setInt(_coinsKey, newBalance);
      
      print('Spent $amount coins for $feature. New balance: $newBalance');
      return true;
    }
    
    print('Insufficient coins for $feature. Required: $amount, Available: $currentCoins');
    return false;
  }

  // Reward coins for watching ads
  static Future<int> rewardForRewardedAd() async {
    return await addCoins(_rewardedAdCoins, 'rewarded_ad');
  }

  static Future<int> rewardForInterstitialAd() async {
    return await addCoins(_interstitialAdCoins, 'interstitial_ad');
  }

  // Premium feature costs
  static int get removeAdsWeekCost => _removeAdsWeekCost;
  static int get removeAdsMonthCost => _removeAdsMonthCost;
  static int get showAllSMSWeekCost => _showAllSMSWeekCost;
  static int get removeFavoritesWeekCost => _removeFavoritesWeekCost;
  static int get showAllCodesWeekCost => _showAllCodesWeekCost;

  // Get total coins earned
  static Future<int> getTotalCoinsEarned() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalCoinsEarnedKey) ?? 0;
  }

  // Reset coins (for testing)
  static Future<void> resetCoins() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_coinsKey);
    await prefs.remove(_totalCoinsEarnedKey);
  }

  // Get coin earning history (for future use)
  static Future<Map<String, int>> getCoinStats() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'current_balance': prefs.getInt(_coinsKey) ?? 0,
      'total_earned': prefs.getInt(_totalCoinsEarnedKey) ?? 0,
      'rewarded_ad_coins': _rewardedAdCoins,
      'interstitial_ad_coins': _interstitialAdCoins,
    };
  }
}
