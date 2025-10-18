// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ussd_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class USSDSectionAdapter extends TypeAdapter<USSDSection> {
  @override
  final int typeId = 0;

  @override
  USSDSection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return USSDSection(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      icon: fields[3] as String,
      codes: (fields[4] as List).cast<USSDCode>(),
      color: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, USSDSection obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.codes)
      ..writeByte(5)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is USSDSectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class USSDCodeAdapter extends TypeAdapter<USSDCode> {
  @override
  final int typeId = 1;

  @override
  USSDCode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return USSDCode(
      id: fields[0] as String,
      code: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      provider: fields[4] as String,
      category: fields[5] as String,
      isFavorite: fields[6] as bool,
      lastUsed: fields[7] as DateTime,
      usageCount: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, USSDCode obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.provider)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.isFavorite)
      ..writeByte(7)
      ..write(obj.lastUsed)
      ..writeByte(8)
      ..write(obj.usageCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is USSDCodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
