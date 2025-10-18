import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Privacy Policy'),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Last updated: January 2024',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24.0),
            
            _buildSection(
              '1. Information We Collect',
              'USSD+ is designed to work completely offline. We do not collect, store, or transmit any personal information to external servers. All data remains on your device.',
            ),
            
            _buildSection(
              '2. SMS Data',
              'The app analyzes SMS messages locally on your device. No SMS content is sent to external servers. All analysis is performed using offline algorithms.',
            ),
            
            _buildSection(
              '3. USSD Codes',
              'USSD codes are stored locally in the app and are not transmitted to external servers. The app does not make any network calls for USSD functionality.',
            ),
            
            _buildSection(
              '4. Permissions',
              'The app may request SMS permissions to analyze messages locally. These permissions are used only for local analysis and are not shared with external parties.',
            ),
            
            _buildSection(
              '5. Data Storage',
              'All data is stored locally on your device using secure local storage. No data is backed up to external cloud services.',
            ),
            
            _buildSection(
              '6. Third-Party Services',
              'The app may include third-party services like AdMob for advertisements. These services have their own privacy policies and data collection practices.',
            ),
            
            _buildSection(
              '7. Children\'s Privacy',
              'USSD+ is not intended for children under 13. We do not knowingly collect personal information from children under 13.',
            ),
            
            _buildSection(
              '8. Changes to Privacy Policy',
              'We may update this privacy policy from time to time. We will notify you of any changes by posting the new privacy policy in the app.',
            ),
            
            _buildSection(
              '9. Contact Us',
              'If you have any questions about this privacy policy, please contact us at privacy@ussdplus.app',
            ),
            
            const SizedBox(height: 32.0),
            const Text(
              'This privacy policy is designed to comply with Google Play Store and Apple App Store requirements for offline apps.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
