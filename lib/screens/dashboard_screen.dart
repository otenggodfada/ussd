import 'package:flutter/material.dart';
import 'package:ussd_plus/theme/theme_generator.dart';
import 'package:ussd_plus/widgets/stats_card.dart';
import 'package:ussd_plus/widgets/recent_activity_card.dart';
import 'package:ussd_plus/widgets/quick_actions_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = ThemeGenerator.generateGradient(ThemeGenerator.themeNumber);
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        elevation: 0,
        title: const Text('USSD+ Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_rounded),
            onPressed: () {
              // Handle notifications
            },
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
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to USSD+',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Your offline USSD and SMS management companion',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onPrimary.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24.0),
            
            // Stats Section
            Text(
              'Usage Statistics',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16.0),
            
            const Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'SMS Analyzed',
                    value: '1,247',
                    icon: Icons.sms,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: StatsCard(
                    title: 'Total Cost',
                    value: 'GHS 45.20',
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16.0),
            
            const Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'USSD Codes',
                    value: '156',
                    icon: Icons.phone,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: StatsCard(
                    title: 'Categories',
                    value: '4',
                    icon: Icons.category,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24.0),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16.0),
            
            const QuickActionsCard(),
            
            const SizedBox(height: 24.0),
            
            // Recent Activity
            Text(
              'Recent Activity',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16.0),
            
            const RecentActivityCard(),
            ],
          ),
        ),
      ),
    );
  }
}
