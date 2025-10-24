// Stub implementation for notification service when flutter_local_notifications is not available

class NotificationService {
  static Future<void> initialize() async {
    // Stub implementation - do nothing
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // Stub implementation - do nothing
  }

  static Future<void> cancelNotification(int id) async {
    // Stub implementation - do nothing
  }

  static Future<void> cancelAllNotifications() async {
    // Stub implementation - do nothing
  }

  static Future<void> showUSSDNotification({
    required String code,
    required String description,
  }) async {
    // Stub implementation - do nothing
  }

  static Future<void> showSMSAnalysisNotification({
    required int messageCount,
    required double totalCost,
  }) async {
    // Stub implementation - do nothing
  }

  static Future<void> showCountryDetectedNotification({
    required String country,
  }) async {
    // Stub implementation - do nothing
  }
}
