import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../features/habit/data/models/habit_model.dart';
import '../../features/pomodoro/data/models/pomodoro_model.dart';
import '../../features/todolist/data/models/task_model.dart';
import 'function.dart';

Future<void> createTaskNotification(TaskModel taskModel) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: taskModel.taskId,
      channelKey: 'task_channel',
      title: "Upcoming Task - ${taskModel.title}",
      body:
          "${taskModel.taskId} - ${DateFormat('jm').format(taskModel.dateTime)}",
      notificationLayout: NotificationLayout.Default,
      displayOnBackground: true,
      displayOnForeground: true,
      wakeUpScreen: true,
      category: NotificationCategory.Reminder,
    ),
    schedule: NotificationCalendar.fromDate(
      date: taskModel.dateTime,
      allowWhileIdle: true,
      preciseAlarm: true,
    ),
  );
}

Future<void> createHabitNotification(HabitModel habitModel, int day) async {
  TimeOfDay t = TimeOfDay.fromDateTime(habitModel.timeOfDay);
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: habitModel.habitId * day,
      channelKey: 'habit_channel',
      title: "Upcoming Habit - ${habitModel.title}",
      body: '${habitModel.habitId} - ${todToString(t)}',
      notificationLayout: NotificationLayout.Default,
      displayOnBackground: true,
      displayOnForeground: true,
      wakeUpScreen: true,
      category: NotificationCategory.Reminder,
    ),
    schedule: NotificationCalendar(
      weekday: day,
      hour: t.hour,
      minute: t.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
      allowWhileIdle: true,
      preciseAlarm: true,
    ),
  );
}

Future<void> createTimerNotification(
    PomodoroModel pomodoroModel, int currentSession) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: pomodoroModel.pomodoroId,
      channelKey: 'pomodoro_channel',
      title: "Pomodoro Timer - ${pomodoroModel.title}",
      body: '$currentSession of ${pomodoroModel.session} sessions completed',
      notificationLayout: NotificationLayout.Default,
      displayOnBackground: true,
      displayOnForeground: true,
      category: NotificationCategory.StopWatch,
    ),
  );
}
