// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SMSMessageAdapter extends TypeAdapter<SMSMessage> {
  @override
  final int typeId = 2;

  @override
  SMSMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SMSMessage(
      id: fields[0] as String,
      sender: fields[1] as String,
      content: fields[2] as String,
      timestamp: fields[3] as DateTime,
      category: fields[4] as SMSCategory,
      cost: fields[5] as double,
      provider: fields[6] as String,
      isRead: fields[7] as bool,
      metadata: (fields[8] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, SMSMessage obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sender)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.cost)
      ..writeByte(6)
      ..write(obj.provider)
      ..writeByte(7)
      ..write(obj.isRead)
      ..writeByte(8)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SMSMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SMSCostSummaryAdapter extends TypeAdapter<SMSCostSummary> {
  @override
  final int typeId = 4;

  @override
  SMSCostSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SMSCostSummary(
      totalCost: fields[0] as double,
      costByCategory: (fields[1] as Map).cast<SMSCategory, double>(),
      totalMessages: fields[2] as int,
      messagesByCategory: (fields[3] as Map).cast<SMSCategory, int>(),
      periodStart: fields[4] as DateTime,
      periodEnd: fields[5] as DateTime,
      expenseByCategory: (fields[6] as Map).cast<SMSCategory, double>(),
      revenueByCategory: (fields[7] as Map).cast<SMSCategory, double>(),
      totalExpenses: fields[8] as double,
      totalRevenue: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SMSCostSummary obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.totalCost)
      ..writeByte(1)
      ..write(obj.costByCategory)
      ..writeByte(2)
      ..write(obj.totalMessages)
      ..writeByte(3)
      ..write(obj.messagesByCategory)
      ..writeByte(4)
      ..write(obj.periodStart)
      ..writeByte(5)
      ..write(obj.periodEnd)
      ..writeByte(6)
      ..write(obj.expenseByCategory)
      ..writeByte(7)
      ..write(obj.revenueByCategory)
      ..writeByte(8)
      ..write(obj.totalExpenses)
      ..writeByte(9)
      ..write(obj.totalRevenue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SMSCostSummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SMSCategoryAdapter extends TypeAdapter<SMSCategory> {
  @override
  final int typeId = 3;

  @override
  SMSCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SMSCategory.telecom;
      case 1:
        return SMSCategory.banking;
      case 2:
        return SMSCategory.utilities;
      case 3:
        return SMSCategory.mobileMoney;
      case 4:
        return SMSCategory.promotional;
      case 5:
        return SMSCategory.other;
      default:
        return SMSCategory.telecom;
    }
  }

  @override
  void write(BinaryWriter writer, SMSCategory obj) {
    switch (obj) {
      case SMSCategory.telecom:
        writer.writeByte(0);
        break;
      case SMSCategory.banking:
        writer.writeByte(1);
        break;
      case SMSCategory.utilities:
        writer.writeByte(2);
        break;
      case SMSCategory.mobileMoney:
        writer.writeByte(3);
        break;
      case SMSCategory.promotional:
        writer.writeByte(4);
        break;
      case SMSCategory.other:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SMSCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
