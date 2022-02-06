// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitModelAdapter extends TypeAdapter<HabitModel> {
  @override
  final int typeId = 4;

  @override
  HabitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitModel(
      habitId: fields[0] as int,
      iconImg: fields[1] as String,
      title: fields[2] as String,
      goals: fields[3] as String,
      timeOfDay: fields[4] as TimeOfDay,
      durationDays: fields[5] as int,
      missed: fields[6] as int,
      streak: fields[7] as int,
      streakLeft: fields[8] as int,
      dayList: (fields[9] as List).cast<int>(),
      checkedDays: (fields[10] as List).cast<bool>(),
      openDays: (fields[11] as List).cast<bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, HabitModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.habitId)
      ..writeByte(1)
      ..write(obj.iconImg)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.goals)
      ..writeByte(4)
      ..write(obj.timeOfDay)
      ..writeByte(5)
      ..write(obj.durationDays)
      ..writeByte(6)
      ..write(obj.missed)
      ..writeByte(7)
      ..write(obj.streak)
      ..writeByte(8)
      ..write(obj.streakLeft)
      ..writeByte(9)
      ..write(obj.dayList)
      ..writeByte(10)
      ..write(obj.checkedDays)
      ..writeByte(11)
      ..write(obj.openDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
