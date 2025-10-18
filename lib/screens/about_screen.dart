import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ussd_plus/widgets/app_logo.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('About USSD+'),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // App Icon and Name
            const SizedBox(height: 40),
            const AppLogo(
              size: 100,
              showText: false,
            ),
            
            const SizedBox(height: 24.0),
            
            Text(
              'USSD+',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8.0),
            
            Text(
              'Version 1.0.0',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 24.0),
            
            // Description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About USSD+',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      'USSD+ is a powerful offline-first app that combines USSD code management with AI-powered SMS analysis. '
                      'Everything works completely offline, ensuring your data stays private and secure on your device.',
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16.0),
            
            // Features
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key Features',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    _buildFeatureItem('📱', 'Offline USSD Codes', 'Access telecom, banking, and utility USSD codes'),
                    _buildFeatureItem('🤖', 'AI SMS Analysis', 'Smart categorization and cost analysis'),
                    _buildFeatureItem('💰', 'Cost Tracking', 'Monitor SMS spending by category'),
                    _buildFeatureItem('🔒', '100% Offline', 'No internet required, complete privacy'),
                    _buildFeatureItem('🎨', 'Dynamic Themes', 'Multiple visual themes and layouts'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16.0),
            
            // Technical Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Technical Information',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    _buildInfoRow('Platform', 'Flutter 3+'),
                    _buildInfoRow('Storage', 'Hive Local Database'),
                    _buildInfoRow('Permissions', 'SMS, Notifications'),
                    _buildInfoRow('Offline', '100% Offline Operation'),
                    _buildInfoRow('Compliance', 'Play Store & App Store Ready'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16.0),
            
            // Developer Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Developer Information',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    _buildInfoRow('Developer', 'USSD+ Team'),
                    _buildInfoRow('Email', 'contact@ussdplus.app'),
                    _buildInfoRow('Website', 'www.ussdplus.app'),
                    _buildInfoRow('Support', 'support@ussdplus.app'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24.0),
            
            // Copyright
            Text(
              '© 2024 USSD+ Team. All rights reserved.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8.0),
            
            Text(
              'Made with ❤️ for offline-first mobile users',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
