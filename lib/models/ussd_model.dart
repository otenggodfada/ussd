import 'package:hive/hive.dart';

part 'ussd_model.g.dart';

@HiveType(typeId: 0)
class USSDSection {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String icon;
  
  @HiveField(4)
  final List<USSDCode> codes;
  
  @HiveField(5)
  final String color;

  USSDSection({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.codes,
    required this.color,
  });
}

@HiveType(typeId: 1)
class USSDCode {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String code;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final String description;
  
  @HiveField(4)
  final String provider;
  
  @HiveField(5)
  final String category;
  
  @HiveField(6)
  final bool isFavorite;
  
  @HiveField(7)
  final DateTime lastUsed;
  
  @HiveField(8)
  final int usageCount;

  USSDCode({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.provider,
    required this.category,
    this.isFavorite = false,
    required this.lastUsed,
    this.usageCount = 0,
  });

  USSDCode copyWith({
    String? id,
    String? code,
    String? name,
    String? description,
    String? provider,
    String? category,
    bool? isFavorite,
    DateTime? lastUsed,
    int? usageCount,
  }) {
    return USSDCode(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      provider: provider ?? this.provider,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      lastUsed: lastUsed ?? this.lastUsed,
      usageCount: usageCount ?? this.usageCount,
    );
  }
}
