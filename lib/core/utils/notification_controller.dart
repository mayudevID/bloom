import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/authentication/data/models/user_data.dart';
import '../../features/authentication/data/repositories/local_auth_repository.dart';
import '../../features/habit/data/models/habit_model.dart';
import '../../features/habit/data/repositories/local_storage_habits_api.dart';
import '../../features/habit/domain/habits_repository.dart';

class NotificationController {
  static const kHabitsCollectionKey = '__habits_collection_key__';

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification notification) async {
    if (notification.channelKey == 'habit_channel') {
      final habitIdTarget = int.tryParse(notification.body!.split(" - ")[0]);

      final sharedPreferences = await SharedPreferences.getInstance();
      final habitsRepository = HabitsRepository(
        habitsApi: LocalStorageHabitsApi(
          plugin: sharedPreferences,
        ),
      );
      final localUserDataRepository = LocalUserDataRepository(
        sharedPreferences: sharedPreferences,
      );

      final habitsJson = sharedPreferences.getString(kHabitsCollectionKey);
      if (habitsJson != null) {
        final habits = List<Map>.from(json.decode(habitsJson) as List)
            .map((jsonMap) =>
                HabitModel.fromJson(Map<String, dynamic>.from(jsonMap)))
            .toList();
        final habitIndex = habits.indexWhere((h) => h.habitId == habitIdTarget);
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
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
    //         (route) => (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);
  }
}
