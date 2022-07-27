import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/habit/data/models/habit_model.dart';
import '../../features/todolist/data/models/task_model.dart';

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
  return DateTime.now().subtract(const Duration(days: 11)).day.toDouble();
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
List<TaskModel> sortTaskByDate(List<TaskModel> taskList) {
  List<TaskModel> dataTask = [];
  for (TaskModel taskModel in taskList) {
    if (taskModel.dateTime.isAfter(DateTime.now())) {
      dataTask.add(taskModel);
    }
  }

  dataTask.sort((t1, t2) => t1.dateTime.compareTo(t1.dateTime));

  return dataTask;
}

// SORT HABITS BY DATE
List<HabitModel> sortHabitsByDate(List<HabitModel> habitList) {
  List<HabitModel> dataHabits = [];
  for (HabitModel habitModel in habitList) {
    for (int day in habitModel.dayList) {
      if (day == DateTime.now().weekday) {
        dataHabits.add(habitModel);
        break;
      }
    }
  }

  dataHabits.sort((t1, t2) => toDouble(TimeOfDay.fromDateTime(t1.timeOfDay))
      .compareTo(toDouble(TimeOfDay.fromDateTime(t2.timeOfDay))));

  return dataHabits;
}

// CHOOSE TASKS BY DATE
List<TaskModel> taskByDateChooser(List<TaskModel> taskList, DateTime date) {
  List<TaskModel> dataTaskNow = <TaskModel>[];
  for (TaskModel taskModel in taskList) {
    if (parseDate(taskModel).isAtSameMomentAs(date)) {
      dataTaskNow.add(taskModel);
    }
  }

  dataTaskNow.sort((t1, t2) => t1.dateTime.compareTo(t2.dateTime));

  return dataTaskNow;
}

// CHOOSE HABITS BY DATE
List<HabitModel> habitByDateChooser(
    List<HabitModel> habitList, DateTime dateSelect) {
  List<HabitModel> dataHabitNow = <HabitModel>[];
  for (HabitModel habitModel in habitList) {
    for (int day in habitModel.dayList) {
      if (day == dateSelect.weekday) {
        dataHabitNow.add(habitModel);
        break;
      }
    }
  }

  dataHabitNow.sort((t1, t2) => toDouble(TimeOfDay.fromDateTime(t1.timeOfDay))
      .compareTo(toDouble(TimeOfDay.fromDateTime(t2.timeOfDay))));

  return dataHabitNow;
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
  await file.writeAsBytes(byteData.buffer.asUint8List(
    byteData.offsetInBytes,
    byteData.lengthInBytes,
  ));

  var pathOld = file.path;
  var lastSeparator = pathOld.lastIndexOf(Platform.pathSeparator);
  var newPath =
      pathOld.substring(0, lastSeparator + 1) + getRandomId().toString();

  return file.rename(newPath);
}

// DECIDE WHICH DAY TO ENABLE
bool decideWhichDayToEnable(DateTime day) {
  if ((day.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
      day.isBefore(DateTime.now().add(const Duration(days: 30))))) {
    return true;
  }
  return false;
}
