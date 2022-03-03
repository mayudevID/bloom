import 'package:hive/hive.dart';
part 'stat.g.dart';

@HiveType(typeId: 5)
class Stat {
  @HiveField(0)
  DateTime dateTime;

  @HiveField(1)
  int missed;

  @HiveField(2)
  int completed;

  @HiveField(3)
  int streakLeft;

  Stat({
    required this.dateTime,
    required this.missed,
    required this.completed,
    required this.streakLeft,
  });
}
