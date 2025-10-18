import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'activity_model.g.dart';

@HiveType(typeId: 3)
enum ActivityType {
  @HiveField(0)
  ussdCodeViewed,
  @HiveField(1)
  ussdCodeCopied,
  @HiveField(2)
  ussdCodeFavorited,
  @HiveField(3)
  smsAnalyzed,
  @HiveField(4)
  categoryViewed,
  @HiveField(5)
  costSummaryViewed,
  @HiveField(6)
  settingsChanged,
  @HiveField(7)
  searchPerformed,
}

@HiveType(typeId: 4)
class Activity {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final ActivityType type;
  
  @HiveField(2)
  final String title;
  
  @HiveField(3)
  final String? description;
  
  @HiveField(4)
  final DateTime timestamp;
  
  @HiveField(5)
  final Map<String, dynamic>? metadata;

  Activity({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    required this.timestamp,
    this.metadata,
  });

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] as String,
      type: ActivityType.values[map['type'] as int],
      title: map['title'] as String,
      description: map['description'] as String?,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'title': title,
      'description': description,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'metadata': metadata,
    };
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }
  }

  ActivityDisplay get display {
    switch (type) {
      case ActivityType.ussdCodeViewed:
        return ActivityDisplay(
          icon: Icons.phone,
          color: const Color(0xFF2196F3), // Blue
        );
      case ActivityType.ussdCodeCopied:
        return ActivityDisplay(
          icon: Icons.content_copy,
          color: const Color(0xFF9C27B0), // Purple
        );
      case ActivityType.ussdCodeFavorited:
        return ActivityDisplay(
          icon: Icons.favorite,
          color: const Color(0xFFE91E63), // Pink/Red
        );
      case ActivityType.smsAnalyzed:
        return ActivityDisplay(
          icon: Icons.sms,
          color: const Color(0xFF4CAF50), // Green
        );
      case ActivityType.categoryViewed:
        return ActivityDisplay(
          icon: Icons.category,
          color: const Color(0xFFFF9800), // Orange
        );
      case ActivityType.costSummaryViewed:
        return ActivityDisplay(
          icon: Icons.attach_money,
          color: const Color(0xFFFFC107), // Amber
        );
      case ActivityType.settingsChanged:
        return ActivityDisplay(
          icon: Icons.settings,
          color: const Color(0xFF607D8B), // Blue Grey
        );
      case ActivityType.searchPerformed:
        return ActivityDisplay(
          icon: Icons.search,
          color: const Color(0xFF00BCD4), // Cyan
        );
    }
  }
}

class ActivityDisplay {
  final IconData icon;
  final Color color;

  ActivityDisplay({required this.icon, required this.color});
}

