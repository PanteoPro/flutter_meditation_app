// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meditation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeditationAdapter extends TypeAdapter<Meditation> {
  @override
  final int typeId = 0;

  @override
  Meditation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meditation(
      date: fields[0] as DateTime,
      seconds: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Meditation obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.seconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeditationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
