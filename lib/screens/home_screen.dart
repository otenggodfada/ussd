import 'package:flutter/material.dart';
import 'package:ussd_plus/widgets/custom_bottom_nav.dart';
import 'package:ussd_plus/screens/dashboard_screen.dart';
import 'package:ussd_plus/screens/favorites_screen.dart';
import 'package:ussd_plus/screens/sms_insights_screen.dart';
import 'package:ussd_plus/screens/ussd_codes_screen.dart';
import 'package:ussd_plus/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  void _navigateToScreen(int index) {
    setState(() {
      _currentIndex = index;
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
