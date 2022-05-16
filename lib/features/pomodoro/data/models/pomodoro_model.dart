import 'package:json_annotation/json_annotation.dart';
part 'pomodoro_model.g.dart';

@JsonSerializable()
class PomodoroModel {
  int pomodoroId;
  String title;
  int session;
  int durationMinutes;

  PomodoroModel({
    required this.pomodoroId,
    required this.title,
    required this.session,
    required this.durationMinutes,
  });

  PomodoroModel copyWith({
    int? pomodoroId,
    String? title,
    int? session,
    int? durationMinutes,
  }) {
    return PomodoroModel(
      pomodoroId: pomodoroId ?? this.pomodoroId,
      title: title ?? this.title,
      session: session ?? this.session,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }

  factory PomodoroModel.fromJson(Map<String, dynamic> json) =>
      _$PomodoroModelFromJson(json);

  Map<String, dynamic> toJson() => _$PomodoroModelToJson(this);
}
