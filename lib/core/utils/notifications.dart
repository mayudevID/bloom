import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/authentication/data/models/user_data.dart';
import '../../features/authentication/data/repositories/local_auth_repository.dart';
import '../../features/habit/data/models/habit_model.dart';
import '../../features/habit/domain/habits_repository.dart';
import '../../features/pomodoro/data/models/pomodoro_model.dart';
import '../../features/todolist/data/models/task_model.dart';
import '../routes/route_name.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> onBackgroundNotificationResponse(
  NotificationResponse notificationResponse,
) async {}

class NotificationService {
  NotificationService._();

  static const String _taskChannelId = 'task_channel';
  static const String _habitChannelId = 'habit_channel';
  static const String _pomodoroChannelId = 'pomodoro_channel';

  static const String _taskType = 'task';
  static const String _habitType = 'habit';
  static const String _todosCollectionKey = '__todos_collection_key__';
  static const String _habitsCollectionKey = '__habits_collection_key__';
  static const String _habitSchedulesKey = '__habit_notification_schedules__';

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;
  static bool _hasProcessedInitialResponse = false;
  static SharedPreferences? _sharedPreferences;
  static HabitsRepository? _habitsRepository;
  static LocalUserDataRepository? _localUserDataRepository;
  static NotificationResponse? _pendingLaunchResponse;

  static Future<void> initialize({
    required SharedPreferences sharedPreferences,
    required HabitsRepository habitsRepository,
    required LocalUserDataRepository localUserDataRepository,
  }) async {
    _sharedPreferences = sharedPreferences;
    _habitsRepository = habitsRepository;
    _localUserDataRepository = localUserDataRepository;

    if (_isInitialized) {
      return;
    }

    tz.initializeTimeZones();
    final timezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone.identifier));

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const initializationSettingsDarwin = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationResponse,
    );

    await _createAndroidChannels();
    await _requestPermissions();

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    _pendingLaunchResponse = launchDetails?.notificationResponse;

    _isInitialized = true;
  }

  static Future<void> processInitialNotificationIfAny() async {
    if (_hasProcessedInitialResponse) {
      return;
    }

    final pending = _pendingLaunchResponse;
    _pendingLaunchResponse = null;
    _hasProcessedInitialResponse = true;

    if (pending != null) {
      await _onNotificationResponse(pending);
    }
  }

  static Future<void> processDueHabitNotifications() async {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) {
      return;
    }

    final raw = sharedPreferences.getString(_habitSchedulesKey);
    if (raw == null || raw.isEmpty) {
      return;
    }

    final Map<String, dynamic> decoded =
        Map<String, dynamic>.from(json.decode(raw) as Map);
    final now = tz.TZDateTime.now(tz.local);

    var hasChanged = false;
    final updatedSchedules = <String, int>{};

    for (final entry in decoded.entries) {
      final scheduleId = int.tryParse(entry.key);
      final scheduledMillis = entry.value as int?;
      if (scheduleId == null || scheduledMillis == null) {
        hasChanged = true;
        continue;
      }

      final habitId = scheduleId ~/ 10;
      final day = scheduleId % 10;
      final habit = _getHabitById(habitId);
      if (habit == null || !habit.dayList.contains(day)) {
        hasChanged = true;
        continue;
      }

      var nextDue = tz.TZDateTime.fromMillisecondsSinceEpoch(
        tz.local,
        scheduledMillis,
      );

      while (!nextDue.isAfter(now)) {
        final didUpdate = await _markHabitNotificationDisplayed(habitId);
        if (!didUpdate) {
          break;
        }
        nextDue = nextDue.add(const Duration(days: 7));
        hasChanged = true;
      }

      updatedSchedules[entry.key] = nextDue.millisecondsSinceEpoch;
    }

    if (hasChanged || updatedSchedules.length != decoded.length) {
      await sharedPreferences.setString(
        _habitSchedulesKey,
        json.encode(updatedSchedules),
      );
    }
  }

  static Future<void> _createAndroidChannels() async {
    final androidPlatform = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlatform == null) {
      return;
    }

    await androidPlatform.createNotificationChannel(
      const AndroidNotificationChannel(
        _taskChannelId,
        'Task notifications',
        description: 'Notification channel for task reminder',
        importance: Importance.max,
      ),
    );
    await androidPlatform.createNotificationChannel(
      const AndroidNotificationChannel(
        _habitChannelId,
        'Habits notifications',
        description: 'Notification channel for habit reminder',
        importance: Importance.max,
      ),
    );
    await androidPlatform.createNotificationChannel(
      const AndroidNotificationChannel(
        _pomodoroChannelId,
        'Pomodoro notifications',
        description: 'Notification channel for pomodoro timer',
        importance: Importance.max,
      ),
    );
  }

  static Future<void> _requestPermissions() async {
    final androidPlatform = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlatform?.requestNotificationsPermission();
    await androidPlatform?.requestExactAlarmsPermission();

    final iosPlatform = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final iosGranted = await iosPlatform?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (kDebugMode && iosGranted == false) {
      debugPrint(
        'iOS local notification permission is denied. '
        'Enable notifications for Bloom in iOS Settings.',
      );
    }

    final macOSPlatform = _plugin.resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>();
    await macOSPlatform?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static NotificationDetails _notificationDetails({
    required String channelId,
    required String channelName,
    required String channelDescription,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        presentBanner: true,
        presentList: true,
        interruptionLevel: InterruptionLevel.active,
      ),
      macOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        presentBanner: true,
        presentList: true,
      ),
    );
  }

  static tz.TZDateTime _nextWeekdayDateTime(DateTime source, int weekday) {
    var scheduled = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      source.hour,
      source.minute,
    );

    while (scheduled.weekday != weekday || !scheduled.isAfter(DateTime.now())) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return tz.TZDateTime.from(scheduled, tz.local);
  }

  static int _habitNotificationId(int habitId, int day) {
    return (habitId * 10) + day;
  }

  static Map<String, dynamic> _payloadFor(String type, int id, {int? day}) {
    return {
      'type': type,
      'id': id,
      if (day != null) 'day': day,
    };
  }

  static Future<void> _onNotificationResponse(
    NotificationResponse response,
  ) async {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) {
      return;
    }

    final Map<String, dynamic> data =
        Map<String, dynamic>.from(json.decode(payload) as Map);

    final type = data['type'] as String?;
    final id = data['id'] as int?;
    if (type == null || id == null) {
      return;
    }

    if (type == _taskType) {
      final task = _getTaskById(id);
      if (task != null) {
        appNavigatorKey.currentState
            ?.pushNamed(RouteName.TASKDETAIL, arguments: task);
      }
      return;
    }

    if (type == _habitType) {
      await _markHabitNotificationDisplayed(id);
      final habit = _getHabitById(id);
      if (habit != null) {
        appNavigatorKey.currentState
            ?.pushNamed(RouteName.HABITDETAIL, arguments: habit);
      }
    }
  }

  static TaskModel? _getTaskById(int id) {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) {
      return null;
    }

    final todosJson = sharedPreferences.getString(_todosCollectionKey);
    if (todosJson == null) {
      return null;
    }

    final todos = List<Map>.from(json.decode(todosJson) as List)
        .map(
            (jsonMap) => TaskModel.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

    final targetIndex = todos.indexWhere((task) => task.taskId == id);
    if (targetIndex < 0) {
      return null;
    }

    return todos[targetIndex];
  }

  static HabitModel? _getHabitById(int id) {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) {
      return null;
    }

    final habitsJson = sharedPreferences.getString(_habitsCollectionKey);
    if (habitsJson == null) {
      return null;
    }

    final habits = List<Map>.from(json.decode(habitsJson) as List)
        .map(
          (jsonMap) => HabitModel.fromJson(Map<String, dynamic>.from(jsonMap)),
        )
        .toList();

    final targetIndex = habits.indexWhere((habit) => habit.habitId == id);
    if (targetIndex < 0) {
      return null;
    }

    return habits[targetIndex];
  }

  static Future<bool> _markHabitNotificationDisplayed(int habitId) async {
    final habit = _getHabitById(habitId);
    if (habit == null) {
      return false;
    }

    final openDaysVal = habit.openDays.where((item) => item == true).length;
    if (openDaysVal >= habit.openDays.length) {
      return false;
    }

    final newOpenDays = List<bool>.from(habit.openDays);
    newOpenDays[openDaysVal] = true;

    final newHabitModel = HabitModel(
      habitId: habit.habitId,
      iconImg: habit.iconImg,
      title: habit.title,
      goals: habit.goals,
      timeOfDay: habit.timeOfDay,
      durationDays: habit.durationDays,
      missed: habit.missed + 1,
      streak: habit.streak,
      streakLeft: habit.streakLeft,
      dayList: habit.dayList,
      checkedDays: habit.checkedDays,
      openDays: newOpenDays,
    );

    final habitsRepository = _habitsRepository;
    final localUserDataRepository = _localUserDataRepository;
    if (habitsRepository == null || localUserDataRepository == null) {
      return false;
    }

    await habitsRepository.saveHabit(newHabitModel);

    final oldUserData = localUserDataRepository.getUserDataDirect();
    final newUserData = UserData(
      userId: oldUserData.userId,
      email: oldUserData.email,
      name: oldUserData.name,
      habitStreak: oldUserData.habitStreak,
      taskCompleted: oldUserData.taskCompleted,
      totalFocus: oldUserData.totalFocus,
      missed: oldUserData.missed + 1,
      completed: oldUserData.completed,
      streakLeft: oldUserData.streakLeft,
    );

    await localUserDataRepository.saveUserData(newUserData);
    return true;
  }

  static Future<void> scheduleTaskNotification(TaskModel taskModel) async {
    final scheduledDate = tz.TZDateTime.from(taskModel.dateTime, tz.local);
    if (!scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await _plugin.zonedSchedule(
      id: taskModel.taskId,
      title: 'Upcoming Task - ${taskModel.title}',
      body:
          '${taskModel.taskId} - ${DateFormat('jm').format(taskModel.dateTime)}',
      scheduledDate: scheduledDate,
      notificationDetails: _notificationDetails(
        channelId: _taskChannelId,
        channelName: 'Task notifications',
        channelDescription: 'Notification channel for task reminder',
      ),
      payload: json.encode(_payloadFor(_taskType, taskModel.taskId)),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> scheduleHabitNotification(
    HabitModel habitModel,
    int day,
  ) async {
    final scheduledDate = _nextWeekdayDateTime(habitModel.timeOfDay, day);
    final notificationId = _habitNotificationId(habitModel.habitId, day);

    await _plugin.zonedSchedule(
      id: notificationId,
      title: 'Upcoming Habit - ${habitModel.title}',
      body:
          '${habitModel.habitId} - ${DateFormat('jm').format(habitModel.timeOfDay)}',
      scheduledDate: scheduledDate,
      notificationDetails: _notificationDetails(
        channelId: _habitChannelId,
        channelName: 'Habits notifications',
        channelDescription: 'Notification channel for habit reminder',
      ),
      payload: json.encode(
        _payloadFor(_habitType, habitModel.habitId, day: day),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );

    await _upsertHabitSchedule(
      notificationId,
      scheduledDate.millisecondsSinceEpoch,
    );
  }

  static Future<void> showTimerNotification(
    PomodoroModel pomodoroModel,
    int currentSession,
  ) async {
    await _plugin.show(
      id: pomodoroModel.pomodoroId,
      title: 'Pomodoro Timer - ${pomodoroModel.title}',
      body: '$currentSession of ${pomodoroModel.session} sessions completed',
      notificationDetails: _notificationDetails(
        channelId: _pomodoroChannelId,
        channelName: 'Pomodoro notifications',
        channelDescription: 'Notification channel for pomodoro timer',
      ),
    );
  }

  static Future<void> cancelTask(int taskId) => _plugin.cancel(id: taskId);

  static Future<void> cancelHabit(int habitId, int day) async {
    final notificationId = _habitNotificationId(habitId, day);
    await _plugin.cancel(id: notificationId);
    await _removeHabitSchedule(notificationId);
  }

  static Future<void> cancelHabitAll(HabitModel habitModel) async {
    for (final day in habitModel.dayList) {
      await cancelHabit(habitModel.habitId, day);
    }
  }

  static Future<void> _upsertHabitSchedule(
    int notificationId,
    int scheduledMillis,
  ) async {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) {
      return;
    }

    final currentRaw = sharedPreferences.getString(_habitSchedulesKey);
    final currentMap = currentRaw == null || currentRaw.isEmpty
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(json.decode(currentRaw) as Map);

    currentMap['$notificationId'] = scheduledMillis;

    await sharedPreferences.setString(
      _habitSchedulesKey,
      json.encode(currentMap),
    );
  }

  static Future<void> _removeHabitSchedule(int notificationId) async {
    final sharedPreferences = _sharedPreferences;
    if (sharedPreferences == null) {
      return;
    }

    final currentRaw = sharedPreferences.getString(_habitSchedulesKey);
    if (currentRaw == null || currentRaw.isEmpty) {
      return;
    }

    final currentMap =
        Map<String, dynamic>.from(json.decode(currentRaw) as Map);
    currentMap.remove('$notificationId');

    await sharedPreferences.setString(
      _habitSchedulesKey,
      json.encode(currentMap),
    );
  }
}

Future<void> initializeNotificationService({
  required SharedPreferences sharedPreferences,
  required HabitsRepository habitsRepository,
  required LocalUserDataRepository localUserDataRepository,
}) {
  return NotificationService.initialize(
    sharedPreferences: sharedPreferences,
    habitsRepository: habitsRepository,
    localUserDataRepository: localUserDataRepository,
  );
}

Future<void> processInitialNotificationIfAny() {
  return NotificationService.processInitialNotificationIfAny();
}

Future<void> processDueHabitNotifications() {
  return NotificationService.processDueHabitNotifications();
}

Future<void> createTaskNotification(TaskModel taskModel) {
  return NotificationService.scheduleTaskNotification(taskModel);
}

Future<void> createHabitNotification(HabitModel habitModel, int day) {
  return NotificationService.scheduleHabitNotification(habitModel, day);
}

Future<void> createTimerNotification(
  PomodoroModel pomodoroModel,
  int currentSession,
) {
  return NotificationService.showTimerNotification(
      pomodoroModel, currentSession);
}

Future<void> cancelTaskNotification(int taskId) {
  return NotificationService.cancelTask(taskId);
}

Future<void> cancelHabitNotification(int habitId, int day) {
  return NotificationService.cancelHabit(habitId, day);
}

Future<void> cancelAllHabitNotifications(HabitModel habitModel) {
  return NotificationService.cancelHabitAll(habitModel);
}
