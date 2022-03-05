import 'package:hive/hive.dart';
part 'pomodoro.g.dart';

@HiveType(typeId: 2)
class PomodoroModel {
  @HiveField(0)
  int pomodoroId;

  @HiveField(1)
  String title;

  @HiveField(2)
  int session;

  @HiveField(3)
  int durationMinutes;

  PomodoroModel({
    required this.pomodoroId,
    required this.title,
    required this.session,
    required this.durationMinutes,
  });
}
