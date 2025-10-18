import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static bool _isInitialized = false;
  
  // RevenueCat API Keys (Replace with your actual keys)
  static const String _androidApiKey = 'your_android_api_key_here';
  static const String _iosApiKey = 'your_ios_api_key_here';
  
  // Product IDs
  static const String _premiumProductId = 'ussd_plus_premium';
  static const String _premiumMonthlyId = 'ussd_plus_premium_monthly';
  static const String _premiumYearlyId = 'ussd_plus_premium_yearly';
  
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize RevenueCat
      await Purchases.setLogLevel(LogLevel.debug);
      
      // Configure with appropriate API key based on platform
      // Note: In a real app, you'd determine the platform and use the correct key
      await Purchases.configure(PurchasesConfiguration(_androidApiKey));
      
      _isInitialized = true;
    } catch (e) {
      print('RevenueCat initialization failed: $e');
    }
  }
  
  static Future<List<Package>> getAvailablePackages() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        return offerings.current!.availablePackages;
      }
      return [];
    } catch (e) {
      print('Failed to get available packages: $e');
      return [];
    }
  }
  
  static Future<bool> purchasePackage(Package package) async {
    try {
      final purchaseResult = await Purchases.purchasePackage(package);
      // According to the new purchases_flutter API, we need to get customerInfo from purchaseResult
      final customerInfo = purchaseResult.customerInfo;
      return customerInfo.entitlements.active.containsKey('premium');
    } catch (e) {
      print('Purchase failed: $e');
      return false;
    }
  }
  
  static Future<bool> restorePurchases() async {
    try {
      final purchaserInfo = await Purchases.restorePurchases();
      return purchaserInfo.entitlements.active.containsKey('premium');
    } catch (e) {
      print('Restore purchases failed: $e');
      return false;
    }
  }
  
  static Future<bool> isPremiumUser() async {
    try {
      final purchaserInfo = await Purchases.getCustomerInfo();
      return purchaserInfo.entitlements.active.containsKey('premium');
    } catch (e) {
      print('Failed to check premium status: $e');
      return false;
    }
  }
  
  static Future<void> logOut() async {
    try {
      await Purchases.logOut();
    } catch (e) {
      print('Logout failed: $e');
    }
  }
  
  // Premium features
  static Future<bool> canAccessAdvancedAnalytics() async {
    return await isPremiumUser();
  }
  
  static Future<bool> canExportData() async {
    return await isPremiumUser();
  }
  
  static Future<bool> canAccessUnlimitedUSSDCodes() async {
    return await isPremiumUser();
  }
  
  static Future<bool> canAccessPrioritySupport() async {
    return await isPremiumUser();
  }
}
