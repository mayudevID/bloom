part of 'edit_habit_cubit.dart';

class EditHabitState extends Equatable {
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

  const EditHabitState({
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

  factory EditHabitState.initial(HabitModel habitModel) {
    return EditHabitState(
      iconImg: habitModel.iconImg,
      title: habitModel.title,
      goals: habitModel.goals,
      timeOfDay: habitModel.timeOfDay,
      durationDays: habitModel.durationDays,
      missed: habitModel.missed,
      streak: habitModel.streak,
      streakLeft: habitModel.streakLeft,
      sunday: habitModel.dayList.contains(7),
      monday: habitModel.dayList.contains(1),
      tuesday: habitModel.dayList.contains(2),
      wednesday: habitModel.dayList.contains(3),
      thursday: habitModel.dayList.contains(4),
      friday: habitModel.dayList.contains(5),
      saturday: habitModel.dayList.contains(6),
      checkedDays: habitModel.checkedDays,
      openDays: habitModel.openDays,
      selectedIcon: iconLocation.indexWhere(
        (element) => element == habitModel.iconImg,
      ),
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

  EditHabitState copyWith({
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
    return EditHabitState(
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
