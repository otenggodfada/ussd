import 'package:flutter/material.dart';
import 'package:ussd_plus/theme/theme_generator.dart';
import 'package:ussd_plus/widgets/recent_activity_card.dart';
import 'package:ussd_plus/widgets/quick_actions_card.dart';
import 'package:ussd_plus/widgets/quick_stats_card.dart';
import 'package:ussd_plus/widgets/quick_dial_card.dart';
import 'package:ussd_plus/widgets/app_logo.dart';
import 'package:ussd_plus/utils/activity_service.dart';
import 'package:ussd_plus/utils/ussd_data_service.dart';
import 'package:ussd_plus/screens/notifications_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int)? onNavigate;

  const DashboardScreen({
    super.key,
    this.onNavigate,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _activityCount = 0;
  int _ussdCodesCount = 0;
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoadingStats = true);
    
    try {
      // Get real activity count
      final activityCount = await ActivityService.getActivityCount();
      
      // Get USSD codes count
      final sections = await USSDDataService.getOfflineUSSDData();
      final codesCount = sections.fold<int>(0, (sum, section) => sum + section.codes.length);
      
      setState(() {
        _activityCount = activityCount;
        _ussdCodesCount = codesCount;
        _isLoadingStats = false;
      });
    } catch (e) {
      setState(() => _isLoadingStats = false);
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = ThemeGenerator.generateGradient(ThemeGenerator.themeNumber);
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Center(
              child: AppLogo(size: 32),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _getFormattedDate(),
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onBackground.withOpacity(0.6),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background decorative elements
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 30,
                    bottom: -10,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: const AppLogo(size: 40),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.offline_bolt_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Offline Mode',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Your USSD & SMS Hub',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Access all your mobile codes and track SMS expenses - no internet needed',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          _buildFeatureBadge('📱 USSD Codes', theme),
                          const SizedBox(width: 8),
                          _buildFeatureBadge('💬 SMS Insights', theme),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24.0),
            
            // Quick Dial - Favorite USSD Codes
            const QuickDialCard(),
            
            const SizedBox(height: 24.0),
            
            // Stats Section
            if (_isLoadingStats)
              Container(
                padding: const EdgeInsets.all(40.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              QuickStatsCard(
                activityCount: _activityCount,
                ussdCodesCount: _ussdCodesCount,
              ),
            
            const SizedBox(height: 24.0),
            
            // Quick Actions
            QuickActionsCard(
              onNavigate: widget.onNavigate,
            ),
            
            const SizedBox(height: 24.0),
            
            // Recent Activity
            const RecentActivityCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureBadge(String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
