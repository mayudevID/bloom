import 'package:json_annotation/json_annotation.dart';
part 'habit_model.g.dart';

@JsonSerializable()
class HabitModel {
  int habitId;
  String iconImg;
  String title;
  String goals;
  DateTime timeOfDay;
  int durationDays;
  int missed;
  int streak;
  int streakLeft;
  List<int> dayList;
  List<bool> checkedDays;
  List<bool> openDays;

  HabitModel({
    required this.habitId,
    required this.iconImg,
    required this.title,
    required this.goals,
    required this.timeOfDay,
    required this.durationDays,
    required this.missed,
    required this.streak,
    required this.streakLeft,
    required this.dayList,
    required this.checkedDays,
    required this.openDays,
  });

  HabitModel copyWith({
    int? habitId,
    String? iconImg,
    String? title,
    String? goals,
    DateTime? timeOfDay,
    int? durationDays,
    int? missed,
    int? streak,
    int? streakLeft,
    List<int>? dayList,
    List<bool>? checkedDays,
    List<bool>? openDays,
  }) {
    return HabitModel(
      habitId: habitId ?? this.habitId,
      iconImg: iconImg ?? this.iconImg,
      title: title ?? this.title,
      goals: goals ?? this.goals,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      durationDays: durationDays ?? this.durationDays,
      missed: missed ?? this.missed,
      streak: streak ?? this.streak,
      streakLeft: streakLeft ?? this.streakLeft,
      dayList: dayList ?? this.dayList,
      checkedDays: checkedDays ?? this.checkedDays,
      openDays: openDays ?? this.openDays,
    );
  }

  factory HabitModel.fromJson(Map<String, dynamic> json) =>
      _$HabitModelFromJson(json);

  Map<String, dynamic> toJson() => _$HabitModelToJson(this);
}
