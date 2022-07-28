import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloom/features/authentication/data/repositories/local_auth_repository.dart';
import 'package:bloom/features/habit/domain/habits_repository.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/authentication/data/models/user_data.dart';
import '../../features/habit/data/models/habit_model.dart';

class NotificationStream extends GetxController {
  NotificationStream(
    this.habitsRepository,
    this.sharedPreferences,
    this.localUserDataRepository,
  );
  final HabitsRepository habitsRepository;
  final SharedPreferences sharedPreferences;
  final LocalUserDataRepository localUserDataRepository;

  static const kHabitsCollectionKey = '__habits_collection_key__';

  @override
  void onInit() {
    super.onInit();

    AwesomeNotifications().displayedStream.listen((notification) async {
      if (notification.channelKey == 'habit_channel') {
        final habitIdTarget = int.tryParse(notification.body!.split(" - ")[0]);

        final habitsJson = sharedPreferences.getString(kHabitsCollectionKey);
        if (habitsJson != null) {
          final habits = List<Map>.from(json.decode(habitsJson) as List)
              .map((jsonMap) =>
                  HabitModel.fromJson(Map<String, dynamic>.from(jsonMap)))
              .toList();
          final habitIndex =
              habits.indexWhere((h) => h.habitId == habitIdTarget);
          final habitModel = habits[habitIndex];
          final openDaysVal =
              habitModel.openDays.where((item) => item == true).length;
          if (openDaysVal < habitModel.openDays.length) {
            final newOpenDays = habitModel.openDays;
            newOpenDays[openDaysVal] = true;
            final newHabitModel = HabitModel(
              habitId: habitModel.habitId,
              iconImg: habitModel.iconImg,
              title: habitModel.title,
              goals: habitModel.goals,
              timeOfDay: habitModel.timeOfDay,
              durationDays: habitModel.durationDays,
              missed: habitModel.missed + 1,
              streak: habitModel.streak,
              streakLeft: habitModel.streakLeft,
              dayList: habitModel.dayList,
              checkedDays: habitModel.checkedDays,
              openDays: newOpenDays,
            );

            habitsRepository.saveHabit(newHabitModel);

            final oldUserData = localUserDataRepository.getUserDataDirect();
            final newUserData = UserData(
              userId: oldUserData.userId,
              email: oldUserData.email,
              photoURL: oldUserData.photoURL,
              name: oldUserData.name,
              habitStreak: oldUserData.habitStreak,
              taskCompleted: oldUserData.taskCompleted,
              totalFocus: oldUserData.totalFocus,
              missed: oldUserData.missed + 1,
              completed: oldUserData.completed,
              streakLeft: oldUserData.streakLeft,
            );

            localUserDataRepository.saveUserData(newUserData);
          }
        }
      }
    });

    AwesomeNotifications().actionStream.listen(
      (notification) async {
        if (notification.channelKey == 'task_channel') {
          // int? taskIdTarget = int.tryParse(notification.body!.split(" - ")[0]);
          // final prefs = await SharedPreferences.getInstance();
          // TaskModel? taskModel =
          //     LocalStorageTodosIdle(prefs).getData(taskIdTarget);
          // dynamic isDeleted = await Navigator.of(context).pushNamed(
          //   RouteName.TASKDETAIL,
          //   arguments: taskModel,
          // );
          // if (isDeleted as bool) {
          //   Future.delayed(
          //     const Duration(milliseconds: 100),
          //     () async {
          //       AwesomeNotifications().cancel(taskModel!.taskId);
          //       context.read<TodosOverviewBloc>().add(
          //             TodosOverviewTodoDeleted(
          //               taskModel,
          //             ),
          //           );
          //     },
          //   );
          // }
        } else if (notification.channelKey == 'habit_channel') {
          // int? habitIdTarget = int.tryParse(notification.body!.split(" - ")[0]);
          // final prefs = await SharedPreferences.getInstance();
          // HabitModel? habitModel =
          //     LocalStorageHabitsIdle(prefs).getData(habitIdTarget);
          // dynamic isDeleted = await Navigator.of(context).pushNamed(
          //   RouteName.HABITDETAIL,
          //   arguments: habitModel,
          // );
          // if (isDeleted as bool) {
          //   Future.delayed(
          //     const Duration(milliseconds: 100),
          //     () async {
          //       for (var i = 0; i < habitModel!.dayList.length; i++) {
          //         AwesomeNotifications().cancel(
          //           habitModel.habitId * habitModel.dayList[i],
          //         );
          //       }
          //       context.read<HabitsOverviewBloc>().add(
          //             HabitsOverviewHabitDeleted(
          //               habitModel,
          //             ),
          //           );
          //     },
          //   );
          // }
        }
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().actionSink.close();
  }
}
