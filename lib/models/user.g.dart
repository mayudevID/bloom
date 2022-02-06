// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      userId: fields[0] as String?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      habitStreak: fields[3] as int,
      taskCompleted: fields[4] as int,
      totalFocus: fields[5] as double,
      missed: fields[6] as int,
      completed: fields[7] as int,
      streakLeft: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.habitStreak)
      ..writeByte(4)
      ..write(obj.taskCompleted)
      ..writeByte(5)
      ..write(obj.totalFocus)
      ..writeByte(6)
      ..write(obj.missed)
      ..writeByte(7)
      ..write(obj.completed)
      ..writeByte(8)
      ..write(obj.streakLeft);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
