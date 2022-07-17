part of 'add_habit_cubit.dart';

class AddHabitState extends Equatable {
  final String iconImg;
  final String title;
  final String goals;
  final DateTime timeOfDay;
  final int durationDays;
  final int missed;
  final int streak;
  final int streakLeft;
  final List<bool> dayList;
  final List<bool> checkedDays;
  final List<bool> openDays;
  final int selectedIcon;

  const AddHabitState({
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
    required this.selectedIcon,
  });

  factory AddHabitState.initial() {
    return AddHabitState(
      iconImg: 'assets/icons/work_habit.png',
      title: '',
      goals: '',
      timeOfDay: DateTime.now(),
      durationDays: 3,
      missed: 0,
      streak: 0,
      streakLeft: 0,
      // ignore: prefer_const_literals_to_create_immutables
      dayList: [false, false, false, false, false, false, false],
      checkedDays: const [],
      openDays: const [],
      selectedIcon: 0,
    );
  }

  @override
  List<Object> get props => [
        iconImg,
        title,
        goals,
        timeOfDay,
        durationDays,
        missed,
        streak,
        streakLeft,
        dayList,
        checkedDays,
        openDays,
        selectedIcon,
      ];

  AddHabitState copyWith({
    String? iconImg,
    String? title,
    String? goals,
    DateTime? timeOfDay,
    int? durationDays,
    int? missed,
    int? streak,
    int? streakLeft,
    List<bool>? dayList,
    List<bool>? checkedDays,
    List<bool>? openDays,
    int? selectedIcon,
  }) {
    return AddHabitState(
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
      selectedIcon: selectedIcon ?? this.selectedIcon,
    );
  }
}
