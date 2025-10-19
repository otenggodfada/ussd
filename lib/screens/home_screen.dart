import 'package:flutter/material.dart';
import 'package:ussd_plus/widgets/custom_bottom_nav.dart';
import 'package:ussd_plus/screens/dashboard_screen.dart';
import 'package:ussd_plus/screens/favorites_screen.dart';
import 'package:ussd_plus/screens/sms_insights_screen.dart';
import 'package:ussd_plus/screens/ussd_codes_screen.dart';
import 'package:ussd_plus/screens/settings_screen.dart';
import 'package:ussd_plus/utils/admob_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _navigationSwitchCount = 0;
  static const int _adFrequency = 3; // Show ad every 2 navigation switches
  
  void _navigateToScreen(int index) {
    // Only count as a switch if it's different from current index
    if (index != _currentIndex) {
      _navigationSwitchCount++;
      
      print('Navigation switch #$_navigationSwitchCount: ${_getScreenName(_currentIndex)} -> ${_getScreenName(index)}');
      
      // Show interstitial ad every 2 switches
      if (_navigationSwitchCount % _adFrequency == 0) {
        print('Showing interstitial ad after $_navigationSwitchCount navigation switches');
        // Add a small delay to ensure smooth navigation
        Future.delayed(const Duration(milliseconds: 300), () {
          AdMobService.showInterstitialAdIfReady(force: true);
        });
      }
    }
    
    setState(() {
      _currentIndex = index;
    });
  }

  String _getScreenName(int index) {
    switch (index) {
      case 0: return 'Dashboard';
      case 1: return 'USSD Codes';
      case 2: return 'SMS Insights';
      case 3: return 'Favorites';
      case 4: return 'Settings';
      default: return 'Unknown';
    }
  }

  // Method to reset navigation counter (useful for testing or user preferences)
  void resetNavigationCounter() {
    setState(() {
      _navigationSwitchCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(onNavigate: _navigateToScreen),    // index 0 - Dashboard button
      const USSDCodesScreen(),                            // index 1 - USSD button
      const SMSInsightsScreen(),                          // index 2 - SMS button (center)
      const FavoritesScreen(),                            // index 3 - Favorites button
      const SettingsScreen(),                             // index 4 - Settings button
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: screens[_currentIndex],
      extendBody: true,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _navigateToScreen,
      ),
    );
  }
}
