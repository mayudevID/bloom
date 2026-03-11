import 'package:json_annotation/json_annotation.dart';
part 'pomodoro_model.g.dart';

@JsonSerializable()
class PomodoroModel {

  PomodoroModel({
    required this.pomodoroId,
    required this.title,
    required this.session,
    required this.durationMinutes,
  });

  factory PomodoroModel.fromJson(Map<String, dynamic> json) =>
      _$PomodoroModelFromJson(json);
  int pomodoroId;
  String title;
  int session;
  int durationMinutes;

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

  static final empty = PomodoroModel(
    title: '',
    session: 0,
    pomodoroId: 0,
    durationMinutes: 0,
  );

  Map<String, dynamic> toJson() => _$PomodoroModelToJson(this);
}
