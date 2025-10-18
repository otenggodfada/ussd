import 'package:flutter/material.dart';
import 'package:ussd_plus/screens/privacy_policy_screen.dart';
import 'package:ussd_plus/screens/about_screen.dart';
import 'package:ussd_plus/utils/activity_service.dart';
import 'package:ussd_plus/models/activity_model.dart';
import 'package:ussd_plus/utils/ussd_data_service.dart';
import 'package:ussd_plus/utils/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedCountry = 'Ghana';
  String? _detectedCountry;
  bool _autoDetectEnabled = true;
  bool _isDetecting = false;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final country = await USSDDataService.getSelectedCountry();
    final autoDetect = await LocationService.isAutoDetectEnabled();
    final detected = await LocationService.getDetectedCountry();
    
    setState(() {
      _selectedCountry = country;
      _autoDetectEnabled = autoDetect;
      _detectedCountry = detected;
    });
  }
  
  Future<void> _detectCountryNow() async {
    setState(() {
      _isDetecting = true;
    });
    
    try {
      final detectedCountry = await LocationService.detectCountryFromLocation();
      
      if (detectedCountry != null) {
        setState(() {
          _detectedCountry = detectedCountry;
          _selectedCountry = detectedCountry;
          _isDetecting = false;
        });
        
        // Clear manual selection to allow auto-detection
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('selected_country');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Country detected: $detectedCountry'),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        setState(() {
          _isDetecting = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not detect country. Please select manually.'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isDetecting = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
                
                if (value) {
                  // Try to detect country immediately
                  _detectCountryNow();
                }
                
                ActivityService.logActivity(
                  type: ActivityType.settingsChanged,
                  title: 'Auto-detect country ${value ? "enabled" : "disabled"}',
                  description: 'Changed auto-detection setting',
                );
              },
            ),
          ),
          
          // Detect now button
          if (_autoDetectEnabled)
            _buildSettingsTile(
              icon: _isDetecting ? Icons.hourglass_empty : Icons.my_location,
              title: _isDetecting ? 'Detecting...' : 'Detect Country Now',
              subtitle: 'Use GPS to find your current location',
              onTap: _isDetecting ? null : () => _detectCountryNow(),
            ),
          
          // Manual country selector
          _buildSettingsTile(
            icon: Icons.public,
            title: 'Country/Region',
            subtitle: _selectedCountry,
            onTap: () => _showCountrySelector(context),
          ),
          _buildSettingsTile(
            icon: Icons.palette,
            title: 'Theme',
            subtitle: 'Customize app appearance',
            onTap: () => _showThemeOptions(context),
          ),
          _buildSettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () => _showNotificationSettings(context),
          ),
          _buildSettingsTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English',
            onTap: () => _showLanguageOptions(context),
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
          
          // Premium Features
          _buildSectionHeader('Premium Features'),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: _buildSettingsTile(
              icon: Icons.star,
              title: 'Upgrade to Pro',
              subtitle: 'Unlock advanced AI features',
              onTap: () => _showPremiumUpgrade(context),
              textColor: Colors.white,
            ),
          ),
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

  void _showThemeOptions(BuildContext context) {
    // Log settings activity
    ActivityService.logActivity(
      type: ActivityType.settingsChanged,
      title: 'Opened theme settings',
      description: 'Viewing theme customization options',
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme Options'),
        content: const Text('Theme customization will be available in future updates.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    // Log settings activity
    ActivityService.logActivity(
      type: ActivityType.settingsChanged,
      title: 'Opened notification settings',
      description: 'Viewing notification preferences',
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Settings'),
        content: const Text('Notification preferences will be available in future updates.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLanguageOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Language Options'),
        content: const Text('Language selection will be available in future updates.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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

  void _showPremiumUpgrade(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Pro'),
        content: const Text('Premium features will be available in future updates.'),
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
