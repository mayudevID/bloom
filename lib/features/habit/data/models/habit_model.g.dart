// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitModel _$HabitModelFromJson(Map<String, dynamic> json) => HabitModel(
      habitId: json['habitId'] as int,
      iconImg: json['iconImg'] as String,
      title: json['title'] as String,
      goals: json['goals'] as String,
      timeOfDay: DateTime.parse(json['timeOfDay'] as String),
      durationDays: json['durationDays'] as int,
      missed: json['missed'] as int,
      streak: json['streak'] as int,
      streakLeft: json['streakLeft'] as int,
      dayList: (json['dayList'] as List<dynamic>).map((e) => e as int).toList(),
      checkedDays:
          (json['checkedDays'] as List<dynamic>).map((e) => e as bool).toList(),
      openDays:
          (json['openDays'] as List<dynamic>).map((e) => e as bool).toList(),
    );

Map<String, dynamic> _$HabitModelToJson(HabitModel instance) =>
    <String, dynamic>{
      'habitId': instance.habitId,
      'iconImg': instance.iconImg,
      'title': instance.title,
      'goals': instance.goals,
      'timeOfDay': instance.timeOfDay.toIso8601String(),
      'durationDays': instance.durationDays,
      'missed': instance.missed,
      'streak': instance.streak,
      'streakLeft': instance.streakLeft,
      'dayList': instance.dayList,
      'checkedDays': instance.checkedDays,
      'openDays': instance.openDays,
    };
