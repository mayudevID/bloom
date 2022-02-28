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
      photoUrl: fields[3] as String,
      habitStreak: fields[4] as int,
      taskCompleted: fields[5] as int,
      totalFocus: fields[6] as double,
      missed: fields[7] as int,
      completed: fields[8] as int,
      streakLeft: fields[9] as int,
      isNewUser: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.photoUrl)
      ..writeByte(4)
      ..write(obj.habitStreak)
      ..writeByte(5)
      ..write(obj.taskCompleted)
      ..writeByte(6)
      ..write(obj.totalFocus)
      ..writeByte(7)
      ..write(obj.missed)
      ..writeByte(8)
      ..write(obj.completed)
      ..writeByte(9)
      ..write(obj.streakLeft)
      ..writeByte(10)
      ..write(obj.isNewUser);
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
