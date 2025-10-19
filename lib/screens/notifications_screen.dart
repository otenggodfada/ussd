import 'package:flutter/material.dart';
import 'package:ussd_plus/models/activity_model.dart';
import 'package:ussd_plus/utils/activity_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Activity> _activities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() => _isLoading = true);
    
    try {
      final activities = await ActivityService.getActivities(limit: 50);
      setState(() {
        _activities = activities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
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
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadActivities,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showNotificationSettings(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16.0),
                  Text('Loading notifications...'),
                ],
              ),
            )
          : _activities.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          size: 64,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        'No notifications yet',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Your recent activities will appear here',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                    bottom: 100.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.notifications_rounded,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Recent Activity',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              '${_activities.length} items',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      
                      // Activity List
                      ..._activities.map((activity) => _buildActivityCard(activity, theme)),
                    ],
                  ),
                ),
    );
  }

  Widget _buildActivityCard(Activity activity, ThemeData theme) {
    final timeAgo = _getTimeAgo(activity.timestamp);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () => _showActivityDetails(activity),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: _getActivityColor(activity.type).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    _getActivityIcon(activity.type),
                    color: _getActivityColor(activity.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12.0),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (activity.description?.isNotEmpty == true) ...[
                        const SizedBox(height: 4.0),
                        Text(
                          activity.description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 12,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            timeAgo,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                              fontSize: 11,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: _getActivityColor(activity.type).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              _getActivityTypeLabel(activity.type),
                              style: TextStyle(
                                color: _getActivityColor(activity.type),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.ussdCodeViewed:
        return Icons.phone_rounded;
      case ActivityType.ussdCodeCopied:
        return Icons.content_copy_rounded;
      case ActivityType.ussdCodeFavorited:
        return Icons.favorite_rounded;
      case ActivityType.smsAnalyzed:
        return Icons.sms_rounded;
      case ActivityType.settingsChanged:
        return Icons.settings_rounded;
      case ActivityType.costSummaryViewed:
        return Icons.analytics_rounded;
      case ActivityType.categoryViewed:
        return Icons.category_rounded;
      case ActivityType.searchPerformed:
        return Icons.search_rounded;
    }
  }

  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.ussdCodeViewed:
        return Colors.blue;
      case ActivityType.ussdCodeCopied:
        return Colors.purple;
      case ActivityType.ussdCodeFavorited:
        return Colors.pink;
      case ActivityType.smsAnalyzed:
        return Colors.green;
      case ActivityType.settingsChanged:
        return Colors.orange;
      case ActivityType.costSummaryViewed:
        return Colors.amber;
      case ActivityType.categoryViewed:
        return Colors.teal;
      case ActivityType.searchPerformed:
        return Colors.cyan;
    }
  }

  String _getActivityTypeLabel(ActivityType type) {
    switch (type) {
      case ActivityType.ussdCodeViewed:
        return 'USSD';
      case ActivityType.ussdCodeCopied:
        return 'Copy';
      case ActivityType.ussdCodeFavorited:
        return 'Favorite';
      case ActivityType.smsAnalyzed:
        return 'SMS';
      case ActivityType.settingsChanged:
        return 'Settings';
      case ActivityType.costSummaryViewed:
        return 'Analytics';
      case ActivityType.categoryViewed:
        return 'Category';
      case ActivityType.searchPerformed:
        return 'Search';
    }
  }

  void _showActivityDetails(Activity activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _getActivityIcon(activity.type),
              color: _getActivityColor(activity.type),
            ),
            const SizedBox(width: 8.0),
            Expanded(child: Text(activity.title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (activity.description?.isNotEmpty == true) ...[
              Text(
                'Description:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4.0),
              Text(activity.description!),
              const SizedBox(height: 16.0),
            ],
            Text(
              'Time: ${_formatDateTime(activity.timestamp)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Type: ${_getActivityTypeLabel(activity.type)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (activity.metadata != null && activity.metadata!.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              Text(
                'Details:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4.0),
              ...activity.metadata!.entries.map((entry) => Text(
                '${entry.key}: ${entry.value}',
                style: Theme.of(context).textTheme.bodySmall,
              )),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
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
}
