import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity_model.dart';
import 'notification_service.dart';

class ActivityService {
  static const String _activitiesKey = 'user_activities';
  static const int _maxActivities =
      50; // Keep only the most recent 50 activities

  static Future<void> logActivity({
    required ActivityType type,
    required String title,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final activities = await getActivities();

      final newActivity = Activity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        title: title,
        description: description,
        timestamp: DateTime.now(),
        metadata: metadata,
      );

      // Add new activity to the beginning
      activities.insert(0, newActivity);

      // Keep only the most recent activities
      if (activities.length > _maxActivities) {
        activities.removeRange(_maxActivities, activities.length);
      }

      // Save to preferences
      final jsonList = activities.map((a) => a.toMap()).toList();
      await prefs.setString(_activitiesKey, json.encode(jsonList));

      // Send notifications for specific activity types
      await _sendNotificationForActivity(newActivity);
    } catch (e) {
      print('Error logging activity: $e');
    }
  }

  static Future<List<Activity>> getActivities({int limit = 10}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_activitiesKey);

      if (jsonString == null || jsonString.isEmpty) {
        return _getDefaultActivities();
      }

      final jsonList = json.decode(jsonString) as List;
      final activities = jsonList
          .map((json) => Activity.fromMap(json as Map<String, dynamic>))
          .toList();

      // Return the most recent activities up to the limit
      return activities.take(limit).toList();
    } catch (e) {
      print('Error getting activities: $e');
      return _getDefaultActivities();
    }
  }

  static Future<void> clearActivities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_activitiesKey);
    } catch (e) {
      print('Error clearing activities: $e');
    }
  }

  static Future<int> getActivityCount() async {
    final activities = await getActivities(limit: 1000);
    return activities.length;
  }

  static Future<Map<ActivityType, int>> getActivityStats() async {
    final activities = await getActivities(limit: 1000);
    final stats = <ActivityType, int>{};

    for (final activity in activities) {
      stats[activity.type] = (stats[activity.type] ?? 0) + 1;
    }

    return stats;
  }

  static List<Activity> _getDefaultActivities() {
    // Provide some initial sample activities for new users
    final now = DateTime.now();
    return [
      Activity(
        id: '1',
        type: ActivityType.ussdCodeViewed,
        title: 'Explored USSD Codes',
        description: 'Viewed available USSD codes',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      Activity(
        id: '2',
        type: ActivityType.smsAnalyzed,
        title: 'SMS Analysis Ready',
        description: 'SMS insights feature available',
        timestamp: now.subtract(const Duration(hours: 5)),
      ),
      Activity(
        id: '3',
        type: ActivityType.categoryViewed,
        title: 'Welcome to USSD+',
        description: 'Get started by exploring features',
        timestamp: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  static Future<void> _sendNotificationForActivity(Activity activity) async {
    try {
      switch (activity.type) {
        case ActivityType.ussdCodeViewed:
          // Extract USSD code from title if possible
          final ussdCode = activity.metadata?['ussdCode'] ?? 'USSD Code';
          await NotificationService.showUSSDNotification(
            code: ussdCode,
            description: activity.description ?? 'USSD code viewed',
          );
          break;
        case ActivityType.smsAnalyzed:
          final messageCount = activity.metadata?['messageCount'] ?? 0;
          final totalCost = activity.metadata?['totalCost'] ?? 0.0;
          await NotificationService.showSMSAnalysisNotification(
            messageCount: messageCount,
            totalCost: totalCost,
          );
          break;
        case ActivityType.settingsChanged:
          if (activity.title.toLowerCase().contains('country')) {
            final country = activity.metadata?['country'] ?? 'Unknown';
            await NotificationService.showCountryDetectedNotification(
              country: country,
            );
          }
          break;
        default:
          // No notification for other activity types
          break;
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
