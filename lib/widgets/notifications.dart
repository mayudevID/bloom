import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloom/models/habit.dart';
import 'package:bloom/models/pomodoro.dart';
import 'package:bloom/models/task.dart';
import 'package:intl/intl.dart';

import '../utils.dart';

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
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: habitModel.habitId * day,
      channelKey: 'habit_channel',
      title: "Upcoming Habit - ${habitModel.title}",
      body: '${habitModel.habitId} - ${todToString(habitModel.timeOfDay)}',
      notificationLayout: NotificationLayout.Default,
      displayOnBackground: true,
      displayOnForeground: true,
      wakeUpScreen: true,
      category: NotificationCategory.Reminder,
    ),
    schedule: NotificationCalendar(
      weekday: day,
      hour: habitModel.timeOfDay.hour,
      minute: habitModel.timeOfDay.minute,
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
      category: NotificationCategory.Alarm,
    ),
  );
}
