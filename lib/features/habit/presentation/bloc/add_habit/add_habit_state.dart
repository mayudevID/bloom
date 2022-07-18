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
  final bool sunday;
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
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
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
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
      sunday: false,
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
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
        sunday,
        monday,
        tuesday,
        wednesday,
        thursday,
        friday,
        saturday,
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
    bool? sunday,
    bool? monday,
    bool? tuesday,
    bool? wednesday,
    bool? thursday,
    bool? friday,
    bool? saturday,
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
      sunday: sunday ?? this.sunday,
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      friday: friday ?? this.friday,
      thursday: thursday ?? this.thursday,
      saturday: saturday ?? this.saturday,
      checkedDays: checkedDays ?? this.checkedDays,
      openDays: openDays ?? this.openDays,
      selectedIcon: selectedIcon ?? this.selectedIcon,
    );
  }
}
