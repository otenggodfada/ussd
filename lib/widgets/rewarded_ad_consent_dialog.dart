import 'package:flutter/material.dart';

class RewardedAdConsentDialog extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onConsentGiven;
  final VoidCallback onConsentDenied;

  const RewardedAdConsentDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onConsentGiven,
    required this.onConsentDenied,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Row(
        children: [
          Icon(
            Icons.video_library_rounded,
            color: theme.colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Watch a short ad to dial this USSD code',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onConsentDenied,
          child: Text(
            'No',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConsentGiven,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.play_arrow_rounded, size: 18),
              const SizedBox(width: 4.0),
              const Text('Watch Ad'),
            ],
          ),
        ),
      ],
    );
  }

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => RewardedAdConsentDialog(
        title: title,
        description: description,
        onConsentGiven: () => Navigator.of(context).pop(true),
        onConsentDenied: () => Navigator.of(context).pop(false),
      ),
    );
  }
}
