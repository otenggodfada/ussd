import 'package:hive/hive.dart';

part 'sms_model.g.dart';

@HiveType(typeId: 2)
class SMSMessage {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String sender;
  
  @HiveField(2)
  final String content;
  
  @HiveField(3)
  final DateTime timestamp;
  
  @HiveField(4)
  final SMSCategory category;
  
  @HiveField(5)
  final double cost;
  
  @HiveField(6)
  final String provider;
  
  @HiveField(7)
  final bool isRead;
  
  @HiveField(8)
  final Map<String, dynamic> metadata;

  SMSMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.category,
    this.cost = 0.0,
    required this.provider,
    this.isRead = false,
    this.metadata = const {},
  });

  SMSMessage copyWith({
    String? id,
    String? sender,
    String? content,
    DateTime? timestamp,
    SMSCategory? category,
    double? cost,
    String? provider,
    bool? isRead,
    Map<String, dynamic>? metadata,
  }) {
    return SMSMessage(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      cost: cost ?? this.cost,
      provider: provider ?? this.provider,
      isRead: isRead ?? this.isRead,
      metadata: metadata ?? this.metadata,
    );
  }
}

@HiveType(typeId: 3)
enum SMSCategory {
  @HiveField(0)
  telecom,
  
  @HiveField(1)
  banking,
  
  @HiveField(2)
  utilities,
  
  @HiveField(3)
  mobileMoney,
  
  @HiveField(4)
  promotional,
  
  @HiveField(5)
  other;

  String get displayName {
    switch (this) {
      case SMSCategory.telecom:
        return 'Telecom';
      case SMSCategory.banking:
        return 'Banking';
      case SMSCategory.utilities:
        return 'Utilities';
      case SMSCategory.mobileMoney:
        return 'Mobile Money';
      case SMSCategory.promotional:
        return 'Promotional';
      case SMSCategory.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case SMSCategory.telecom:
        return '📱';
      case SMSCategory.banking:
        return '🏦';
      case SMSCategory.utilities:
        return '⚡';
      case SMSCategory.mobileMoney:
        return '💰';
      case SMSCategory.promotional:
        return '📢';
      case SMSCategory.other:
        return '📄';
    }
  }
}

@HiveType(typeId: 4)
class SMSCostSummary {
  @HiveField(0)
  final double totalCost;
  
  @HiveField(1)
  final Map<SMSCategory, double> costByCategory;
  
  @HiveField(2)
  final int totalMessages;
  
  @HiveField(3)
  final Map<SMSCategory, int> messagesByCategory;
  
  @HiveField(4)
  final DateTime periodStart;
  
  @HiveField(5)
  final DateTime periodEnd;
  
  @HiveField(6)
  final Map<SMSCategory, double> expenseByCategory;
  
  @HiveField(7)
  final Map<SMSCategory, double> revenueByCategory;
  
  @HiveField(8)
  final double totalExpenses;
  
  @HiveField(9)
  final double totalRevenue;

  SMSCostSummary({
    required this.totalCost,
    required this.costByCategory,
    required this.totalMessages,
    required this.messagesByCategory,
    required this.periodStart,
    required this.periodEnd,
    this.expenseByCategory = const {},
    this.revenueByCategory = const {},
    this.totalExpenses = 0.0,
    this.totalRevenue = 0.0,
  });

  double getCostForCategory(SMSCategory category) {
    return costByCategory[category] ?? 0.0;
  }

  int getMessageCountForCategory(SMSCategory category) {
    return messagesByCategory[category] ?? 0;
  }

  double getExpenseForCategory(SMSCategory category) {
    return expenseByCategory[category] ?? 0.0;
  }

  double getRevenueForCategory(SMSCategory category) {
    return revenueByCategory[category] ?? 0.0;
  }

  double getNetAmountForCategory(SMSCategory category) {
    return getRevenueForCategory(category) - getExpenseForCategory(category);
  }
}
