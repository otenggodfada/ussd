import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ussd_plus/theme/theme_generator.dart';

/// A beautiful, simple rating dialog without external packages
class RateUsDialog extends StatelessWidget {
  final String? appName;

  const RateUsDialog({
    super.key,
    this.appName = 'USSD+',
  });

  static Future<void> show(BuildContext context, {String? appName}) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => RateUsDialog(appName: appName),
    );
  }

  Future<void> _handleYes(BuildContext context) async {
    // Close dialog first
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    
    // Open Play Store URL
    const String packageName = 'com.redizeuz.ussdplus';
    final Uri playStoreUrl = Uri.parse(
      'https://play.google.com/store/apps/details?id=$packageName',
    );
    
    if (await canLaunchUrl(playStoreUrl)) {
      await launchUrl(
        playStoreUrl,
        mode: LaunchMode.externalApplication,
      );
    } else {
      // Fallback: show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open Play Store'),
          ),
        );
      }
    }
  }

  Future<void> _handleLater(BuildContext context) async {
    // Just close the dialog
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = ThemeGenerator.generateGradient(ThemeGenerator.themeNumber);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Enjoying $appName?',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Your feedback helps us improve and reach more users! 🙌',
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blue.withOpacity(0.2),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: Colors.blue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Takes just 10 seconds',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Later button
        TextButton(
          onPressed: () => _handleLater(context),
          child: Text(
            'Later',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
          ),
        ),
        
        // Yes button (primary action)
        ElevatedButton.icon(
          onPressed: () => _handleYes(context),
          icon: const Icon(Icons.star, size: 20),
          label: const Text('Yes'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

/// A simpler rate button for settings screen
class RateUsButton extends StatelessWidget {
  final IconData icon;
  final String text;

  const RateUsButton({
    super.key,
    this.icon = Icons.star_outline,
    this.text = 'Rate the App',
  });

  static Future<void> showRatingDialog(BuildContext context) async {
    await RateUsDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      color: theme.colorScheme.surface,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.amber.withOpacity(0.2),
          child: Icon(
            icon,
            color: Colors.amber.shade700,
          ),
        ),
        title: Text(text),
        subtitle: Text(
          'Help us improve by sharing your feedback',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
        onTap: () => showRatingDialog(context),
      ),
    );
  }
}

