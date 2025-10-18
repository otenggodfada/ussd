import 'package:flutter/material.dart';
import 'package:ussd_plus/theme/theme_generator.dart';

class QuickActionsCard extends StatelessWidget {
  final Function(int)? onNavigate;

  const QuickActionsCard({
    super.key,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = ThemeGenerator.generateGradient(ThemeGenerator.themeNumber);
    
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.flash_on_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Quick Actions',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  'Search USSD',
                  Icons.search,
                  gradient,
                  () {
                    // Navigate to USSD Codes screen (index 1)
                    if (onNavigate != null) {
                      onNavigate!(1);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Analyze SMS',
                  Icons.sms,
                  gradient,
                  () {
                    // Navigate to SMS Insights screen (index 2)
                    if (onNavigate != null) {
                      onNavigate!(2);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  'View Favorites',
                  Icons.favorite,
                  gradient,
                  () {
                    // Navigate to Favorites screen (index 3)
                    if (onNavigate != null) {
                      onNavigate!(3);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Settings',
                  Icons.settings,
                  gradient,
                  () {
                    // Navigate to Settings screen (index 4)
                    if (onNavigate != null) {
                      onNavigate!(4);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Gradient gradient,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
