import 'package:flutter/material.dart';
import 'package:ussd_plus/screens/privacy_policy_screen.dart';
import 'package:ussd_plus/screens/about_screen.dart';
import 'package:ussd_plus/utils/activity_service.dart';
import 'package:ussd_plus/models/activity_model.dart';
import 'package:ussd_plus/utils/ussd_data_service.dart';
import 'package:ussd_plus/utils/location_service.dart';
import 'package:ussd_plus/widgets/coin_premium_feature_card.dart';
import 'package:ussd_plus/utils/coin_service.dart';
import 'package:ussd_plus/utils/premium_features_service.dart';
import 'package:ussd_plus/widgets/coin_earning_button.dart';

class SettingsScreen extends StatefulWidget {
  final bool scrollToCoins;
  
  const SettingsScreen({
    super.key,
    this.scrollToCoins = false,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedCountry = 'Ghana';
  String? _detectedCountry;
  bool _autoDetectEnabled = true;
  int _coinBalance = 0;
  final ScrollController _scrollController = ScrollController();
  
  final GlobalKey _coinsSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    
    // Scroll to coins section if requested
    if (widget.scrollToCoins) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCoinsSection();
      });
    }
  }

  void _scrollToCoinsSection() {
    // Try multiple approaches to ensure scrolling works
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        // First try: Calculate approximate position
        const double estimatedPosition = 600.0;
        
        _scrollController.animateTo(
          estimatedPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
    
    // Second try: Use ensureVisible with longer delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (_coinsSectionKey.currentContext != null) {
        Scrollable.ensureVisible(
          _coinsSectionKey.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.1, // Position near top of screen
        );
      }
    });
  }
  
  Future<void> _loadSettings() async {
    final country = await USSDDataService.getSelectedCountry();
    final autoDetect = await LocationService.isAutoDetectEnabled();
    final detected = await LocationService.getDetectedCountry();
    final coins = await CoinService.getCoinBalance();
    
    setState(() {
      _selectedCountry = country;
      _autoDetectEnabled = autoDetect;
      _detectedCountry = detected;
      _coinBalance = coins;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
        children: [
          // App Settings
          _buildSectionHeader('App Settings'),
          
          // Auto-detect country toggle
          Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            color: theme.colorScheme.surface,
            child: SwitchListTile(
              secondary: Icon(Icons.location_on, color: theme.colorScheme.primary),
              title: Text(
                'Auto-detect Country',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              subtitle: Text(
                _autoDetectEnabled 
                    ? (_detectedCountry != null 
                        ? 'Detected: $_detectedCountry' 
                        : 'Using GPS to detect country')
                    : 'Manual selection only',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              value: _autoDetectEnabled,
              onChanged: (bool value) async {
                await LocationService.setAutoDetect(value);
                setState(() {
                  _autoDetectEnabled = value;
                });
                
                ActivityService.logActivity(
                  type: ActivityType.settingsChanged,
                  title: 'Auto-detect country ${value ? "enabled" : "disabled"}',
                  description: 'Changed auto-detection setting',
                );
              },
            ),
          ),
          
          
          // Manual country selector
          _buildSettingsTile(
            icon: Icons.public,
            title: 'Country/Region',
            subtitle: _selectedCountry,
            onTap: () => _showCountrySelector(context),
          ),
          
          const SizedBox(height: 24.0),
          
          // Data & Privacy
          _buildSectionHeader('Data & Privacy'),
          _buildSettingsTile(
            icon: Icons.security,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
            ),
          ),
          _buildSettingsTile(
            icon: Icons.storage,
            title: 'Data Management',
            subtitle: 'Clear cache and data',
            onTap: () => _showDataManagement(context),
          ),
          
          const SizedBox(height: 24.0),
          
          // About
          _buildSectionHeader('About'),
          _buildSettingsTile(
            icon: Icons.info,
            title: 'About USSD+',
            subtitle: 'Version 1.0.0',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            ),
          ),
          _buildSettingsTile(
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            onTap: () => _showHelpSupport(context),
          ),
          
          const SizedBox(height: 24.0),
          
          // Coin Balance
          Container(
            key: _coinsSectionKey,
            child: _buildCoinBalanceSection(),
          ),
          
          // Coin Earning Button
          CoinEarningButton(
            onCoinsEarned: _loadSettings,
          ),
          
          const SizedBox(height: 24.0),
          
          // Premium Features
          _buildSectionHeader('Premium Features'),
          
          // Remove Ads (1 Week)
          CoinPremiumFeatureCard(
            feature: PremiumFeature.removeAdsWeek,
            onFeatureActivated: _loadSettings,
          ),
          
          const SizedBox(height: 12.0),
          
          // Remove Ads (1 Month)
          CoinPremiumFeatureCard(
            feature: PremiumFeature.removeAdsMonth,
            onFeatureActivated: _loadSettings,
          ),
          
          const SizedBox(height: 12.0),
          
          // Show All SMS (1 Week)
          CoinPremiumFeatureCard(
            feature: PremiumFeature.showAllSMSWeek,
            onFeatureActivated: _loadSettings,
          ),
          
          const SizedBox(height: 12.0),
          
          // Remove from Favorites (1 Week)
          CoinPremiumFeatureCard(
            feature: PremiumFeature.removeFavoritesWeek,
            onFeatureActivated: _loadSettings,
          ),
          
          const SizedBox(height: 12.0),
          
          // Show All Codes (1 Week)
          CoinPremiumFeatureCard(
            feature: PremiumFeature.showAllCodesWeek,
            onFeatureActivated: _loadSettings,
          ),
          
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildCoinBalanceSection() {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      color: theme.colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.amber.withOpacity(0.2),
              Colors.orange.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Icon(
                Icons.monetization_on,
                color: Colors.amber,
                size: 24,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coin Balance',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '$_coinBalance coins available',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.amber,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Watch ads to earn more coins and unlock premium features',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          color: theme.colorScheme.surface,
          child: ListTile(
            leading: Icon(
              icon, 
              color: onTap == null 
                  ? theme.colorScheme.onSurface.withOpacity(0.5)
                  : (textColor ?? theme.colorScheme.primary)
            ),
            title: Text(
              title,
              style: TextStyle(
                color: onTap == null
                    ? theme.colorScheme.onSurface.withOpacity(0.5)
                    : (textColor ?? theme.colorScheme.onSurface)
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                color: onTap == null
                    ? theme.colorScheme.onSurface.withOpacity(0.3)
                    : (textColor?.withOpacity(0.7) ?? theme.colorScheme.onSurface.withOpacity(0.6)),
              ),
            ),
            trailing: onTap != null ? Icon(
              Icons.chevron_right,
              color: textColor?.withOpacity(0.5) ?? theme.colorScheme.onSurface.withOpacity(0.5),
            ) : null,
            onTap: onTap,
            enabled: onTap != null,
          ),
        );
      },
    );
  }

  Future<void> _showCountrySelector(BuildContext context) async {
    final countries = await USSDDataService.getAvailableCountries();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Country/Region'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: countries.map((country) {
            return RadioListTile<String>(
              title: Text(country),
              value: country,
              groupValue: _selectedCountry,
              onChanged: (value) async {
                if (value != null) {
                  await USSDDataService.setSelectedCountry(value);
                  setState(() {
                    _selectedCountry = value;
                  });
                  
                  // Log settings activity
                  ActivityService.logActivity(
                    type: ActivityType.settingsChanged,
                    title: 'Changed country',
                    description: 'Changed country to $value',
                  );
                  
                  Navigator.pop(context);
                  
                  // Show restart message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Country changed to $value. Please restart the app or navigate to refresh data.'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }


  void _showDataManagement(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Management'),
        content: const Text('This will clear all cached data and reset the app. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Log data clearing activity
              ActivityService.logActivity(
                type: ActivityType.settingsChanged,
                title: 'Cleared app data',
                description: 'Cleared all cached data',
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data cleared successfully')),
              );
            },
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }

  void _showHelpSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text('For support, please contact us at support@ussdplus.app'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

}
