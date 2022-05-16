import 'dart:collection';
import 'dart:io';
import 'package:bloom/features/pomodoro/data/models/pomodoro_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/habit/data/models/habit_model.dart';
import '../../features/todolist/data/models/task_model.dart';

// DEFAULT PHOTO
const defaultPhoto =
    'https://firebasestorage.googleapis.com/v0/b/bloom-88be1.appspot.com/o/profilePicture%2Fdefault.png?alt=media&token=5f6b93d6-5bf0-422c-a129-90fc04da9886';

// GET WIDTH
double getWidth(double sizeDesign, BuildContext context) {
  return MediaQuery.of(context).size.width * sizeDesign / 360;
}

// GET HEIGHT
double getHeight(double sizeDesign, BuildContext context) {
  return MediaQuery.of(context).size.height * sizeDesign / 800;
}

// ADD TWO DIGIT
String twoDigits(int n) => n.toString().padLeft(2, '0');

// SUBTRACT DATE
double getSubtractTwelveDaysAgo() {
  return DateTime.now().subtract(const Duration(days: 12)).day.toDouble();
}

// GET NUMBER OF DAYS IN THIS MONTH
int getNumberOfDays() {
  DateTime now = DateTime.now();
  DateTime lastDayOfMonth = DateTime(
    now.year,
    (now.day < 15) ? now.month : now.month + 1,
    0,
  );
  return lastDayOfMonth.day;
}

// CONVERT TIMEOFDAY TO FORMATTED 'jm'
String todToString(TimeOfDay timeOfDay) {
  String newFormat;
  int hours = timeOfDay.hour;
  int minutes = timeOfDay.minute;
  if (hours > 13) {
    hours = hours % 12;
    newFormat = twoDigits(hours) + ":" + twoDigits(minutes) + " PM";
  } else {
    newFormat = twoDigits(hours) + ":" + twoDigits(minutes) + " AM";
  }
  return newFormat;
}

// GENERATE RANDOM ID
int getRandomId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000000);
}

// CONVERT TIMEOFDAY TO DOUBLE
double toDouble(TimeOfDay myTime) {
  return myTime.hour + myTime.minute / 60.0;
}

// GREETING FUNCTION
String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 11) {
    return 'Good Morning';
  }
  if (hour < 18) {
    return 'Good Afternoon';
  }
  return 'Good Evening';
}

// PARSING DATE
DateTime parseDate(TaskModel taskModel) {
  DateTime dateTimeNow = DateTime(
    taskModel.dateTime.year,
    taskModel.dateTime.month,
    taskModel.dateTime.day,
  );
  return dateTimeNow;
}

// SORT TASKS BY DATE
Map<int, TaskModel> sortTaskByDate(List<TaskModel> taskList) {
  Map<int, TaskModel> dataTask = <int, TaskModel>{};
  for (var i = 0; i < taskList.length; i++) {
    dataTask[i] = taskList[i];
  }

  List sortedKeys = dataTask.keys.toList(growable: false)
    ..sort(
        (k1, k2) => dataTask[k1]!.dateTime.compareTo(dataTask[k2]!.dateTime));

  LinkedHashMap<int, TaskModel> sortedTask = LinkedHashMap.fromIterable(
    sortedKeys,
    key: (k) => k,
    value: (k) => dataTask[k] as TaskModel,
  );
  return sortedTask;
}

// SORT HABITS BY DATE
Map<int, HabitModel> sortHabitsByDate(List<HabitModel> habitList) {
  Map<int, HabitModel> dataHabits = <int, HabitModel>{};
  for (var i = 0; i < habitList.length; i++) {
    HabitModel habitModel = habitList[i];
    for (var j = 0; j < habitModel.dayList.length; j++) {
      if (habitModel.dayList[j] == DateTime.now().weekday) {
        dataHabits[i] = habitModel;
      }
    }
  }

  List sortedKeys = dataHabits.keys.toList(growable: false)
    ..sort((k1, k2) =>
        toDouble(TimeOfDay.fromDateTime(dataHabits[k1]!.timeOfDay)).compareTo(
            toDouble(TimeOfDay.fromDateTime(dataHabits[k2]!.timeOfDay))));

  LinkedHashMap<int, HabitModel> sortedHabits = LinkedHashMap.fromIterable(
    sortedKeys,
    key: (k) => k,
    value: (k) => dataHabits[k] as HabitModel,
  );
  return sortedHabits;
}

// CHOOSE TASKS BY DATE
Map<int, TaskModel> taskByDateChooser(
    List<TaskModel> taskList, DateTime dateSelect) {
  Map<int, TaskModel> dataTaskNow = <int, TaskModel>{};
  for (var i = 0; i < taskList.length; i++) {
    TaskModel taskModel = taskList[i];
    if (parseDate(taskModel).isAtSameMomentAs(dateSelect)) {
      dataTaskNow[i] = taskModel;
    }
  }

  List sortedKeys = dataTaskNow.keys.toList(growable: false)
    ..sort((k1, k2) =>
        dataTaskNow[k1]!.dateTime.compareTo(dataTaskNow[k2]!.dateTime));

  LinkedHashMap<int, TaskModel> sortedNowTask = LinkedHashMap.fromIterable(
    sortedKeys,
    key: (k) => k,
    value: (k) => dataTaskNow[k] as TaskModel,
  );
  return sortedNowTask;
}

// CHOOSE HABITS BY DATE
Map<int, HabitModel> habitByDateChooser(
    List<HabitModel> habitList, DateTime dateSelect) {
  Map<int, HabitModel> dataHabitsNow = <int, HabitModel>{};
  for (var i = 0; i < habitList.length; i++) {
    HabitModel habitModel = habitList[i];
    for (var j = 0; j < habitModel.dayList.length; j++) {
      if (habitModel.dayList[j] == dateSelect.weekday) {
        dataHabitsNow[i] = habitModel;
      }
    }
  }

  List sortedKeys = dataHabitsNow.keys.toList(growable: false)
    ..sort((k1, k2) => toDouble(
            TimeOfDay.fromDateTime(dataHabitsNow[k1]!.timeOfDay))
        .compareTo(
            toDouble(TimeOfDay.fromDateTime(dataHabitsNow[k2]!.timeOfDay))));

  LinkedHashMap<int, HabitModel> sortedNowHabits = LinkedHashMap.fromIterable(
    sortedKeys,
    key: (k) => k,
    value: (k) => dataHabitsNow[k] as HabitModel,
  );
  return sortedNowHabits;
}

// POMODORO TO MAP
// Map<int, PomodoroModel> pomodoroToMap(Box pomodoroDb) {
//   Map<int, PomodoroModel> dataPomodoro = <int, PomodoroModel>{};
//   for (var i = 0; i < pomodoroDb.length; i++) {
//     PomodoroModel pomodoroModel = pomodoroDb.getAt(i);
//     dataPomodoro[i] = pomodoroModel;
//   }
//   return dataPomodoro;
// }

// CONVERT ASSETS TO FILE IMAGE
Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

// DECIDE WHICH DAY TO ENABLE
bool decideWhichDayToEnable(DateTime day) {
  if ((day.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
      day.isBefore(DateTime.now().add(const Duration(days: 30))))) {
    return true;
  }
  return false;
}
