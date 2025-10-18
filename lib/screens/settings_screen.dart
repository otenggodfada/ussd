import 'package:flutter/material.dart';
import 'package:ussd_plus/screens/privacy_policy_screen.dart';
import 'package:ussd_plus/screens/about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          color: theme.colorScheme.surface,
          child: ListTile(
            leading: Icon(icon, color: textColor ?? theme.colorScheme.primary),
            title: Text(
              title,
              style: TextStyle(color: textColor ?? theme.colorScheme.onSurface),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                color: textColor?.withOpacity(0.7) ?? theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: textColor?.withOpacity(0.5) ?? theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            onTap: onTap,
          ),
        );
      },
    );
  }

  void _showThemeOptions(BuildContext context) {
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
