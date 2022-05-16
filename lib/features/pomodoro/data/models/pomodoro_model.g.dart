// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PomodoroModel _$PomodoroModelFromJson(Map<String, dynamic> json) =>
    PomodoroModel(
      pomodoroId: json['pomodoroId'] as int,
      title: json['title'] as String,
      session: json['session'] as int,
      durationMinutes: json['durationMinutes'] as int,
    );

Map<String, dynamic> _$PomodoroModelToJson(PomodoroModel instance) =>
    <String, dynamic>{
      'pomodoroId': instance.pomodoroId,
      'title': instance.title,
      'session': instance.session,
      'durationMinutes': instance.durationMinutes,
    };
