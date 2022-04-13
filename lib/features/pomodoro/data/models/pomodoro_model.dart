import 'package:bloom/features/pomodoro/domain/entities/pomodoro.dart';

class PomodoroModel extends Pomodoro {
  PomodoroModel({
    required int pomodoroId,
    required String title,
    required int session,
    required int durationMinutes,
  }) : super(
          pomodoroId: pomodoroId,
          title: title,
          session: session,
          durationMinutes: durationMinutes,
        );

  factory PomodoroModel.fromJson(Map<String, dynamic> json) {
    return PomodoroModel(
      pomodoroId: json["pomodoroId"],
      title: json["title"],
      session: json["session"],
      durationMinutes: json["durationMinutes"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pomodoroId": pomodoroId,
      "title": title,
      "session": session,
      "durationMinutes": durationMinutes,
    };
  }
}
