// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 4;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      id: fields[0] as String,
      type: fields[1] as ActivityType,
      title: fields[2] as String,
      description: fields[3] as String?,
      timestamp: fields[4] as DateTime,
      metadata: (fields[5] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivityTypeAdapter extends TypeAdapter<ActivityType> {
  @override
  final int typeId = 3;

  @override
  ActivityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActivityType.ussdCodeViewed;
      case 1:
        return ActivityType.ussdCodeCopied;
      case 2:
        return ActivityType.ussdCodeFavorited;
      case 3:
        return ActivityType.smsAnalyzed;
      case 4:
        return ActivityType.categoryViewed;
      case 5:
        return ActivityType.costSummaryViewed;
      case 6:
        return ActivityType.settingsChanged;
      case 7:
        return ActivityType.searchPerformed;
      default:
        return ActivityType.ussdCodeViewed;
    }
  }

  @override
  void write(BinaryWriter writer, ActivityType obj) {
    switch (obj) {
      case ActivityType.ussdCodeViewed:
        writer.writeByte(0);
        break;
      case ActivityType.ussdCodeCopied:
        writer.writeByte(1);
        break;
      case ActivityType.ussdCodeFavorited:
        writer.writeByte(2);
        break;
      case ActivityType.smsAnalyzed:
        writer.writeByte(3);
        break;
      case ActivityType.categoryViewed:
        writer.writeByte(4);
        break;
      case ActivityType.costSummaryViewed:
        writer.writeByte(5);
        break;
      case ActivityType.settingsChanged:
        writer.writeByte(6);
        break;
      case ActivityType.searchPerformed:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
