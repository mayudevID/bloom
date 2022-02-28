import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'models/habit.dart';
import 'models/task.dart';
import 'package:path_provider/path_provider.dart';

// DEFAULT PHOTO
const defaultPhoto =
    'https://firebasestorage.googleapis.com/v0/b/bloom-88be1.appspot.com/o/profilePicture%2Fdefault.png?alt=media&token=5f6b93d6-5bf0-422c-a129-90fc04da9886';

// GET WIDTH
double getWidth(double sizeDesign) => Get.width * sizeDesign / 360;

// GET HEIGHT
double getHeight(double sizeDesign) => Get.height * sizeDesign / 800;

// ADD TWO DIGIT
String twoDigits(int n) => n.toString().padLeft(2, '0');

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
Map<int, TaskModel?> sortTaskByDate(Box<dynamic> taskDb) {
  Map<int, TaskModel> dataTask = <int, TaskModel>{};
  for (var i = 0; i < taskDb.length; i++) {
    TaskModel taskModel = taskDb.getAt(i);
    dataTask[i] = taskModel;
  }

  List sortedKeys = dataTask.keys.toList(growable: false)
    ..sort(
        (k1, k2) => dataTask[k1]!.dateTime.compareTo(dataTask[k2]!.dateTime));

  LinkedHashMap<int, TaskModel?> sortedTask = LinkedHashMap.fromIterable(
    sortedKeys,
    key: (k) => k,
    value: (k) => dataTask[k],
  );
  return sortedTask;
}

// SORT HABITS BY DATE
Map<int, HabitModel?> sortHabitByDate(Box<dynamic> habitDb) {
  Map<int, HabitModel> dataHabit = <int, HabitModel>{};
  for (var i = 0; i < habitDb.length; i++) {
    HabitModel habitModel = habitDb.getAt(i);
    for (var j = 0; j < habitModel.dayList.length; j++) {
      if (habitModel.dayList[j] == DateTime.now().weekday) {
        dataHabit[i] = habitModel;
      }
    }
  }

  List sortedKeys = dataHabit.keys.toList(growable: false)
    ..sort((k1, k2) => toDouble(dataHabit[k1]!.timeOfDay)
        .compareTo(toDouble(dataHabit[k2]!.timeOfDay)));

  LinkedHashMap<int, HabitModel?> sortedHabit = LinkedHashMap.fromIterable(
    sortedKeys,
    key: (k) => k,
    value: (k) => dataHabit[k],
  );
  return sortedHabit;
}

// CHOOSE TASKS BY DATE
Map<int, TaskModel?> taskByDateChooser(
    Box<dynamic> taskDb, DateTime dateSelect) {
  Map<int, TaskModel> dataTaskNow = <int, TaskModel>{};
  for (var i = 0; i < taskDb.length; i++) {
    TaskModel taskModel = taskDb.getAt(i);
    if (parseDate(taskModel).isAtSameMomentAs(dateSelect)) {
      dataTaskNow[i] = taskModel;
    }
  }

  List sortedKeys = dataTaskNow.keys.toList(growable: false)
    ..sort((k1, k2) =>
        dataTaskNow[k1]!.dateTime.compareTo(dataTaskNow[k2]!.dateTime));

  LinkedHashMap<int, TaskModel?> sortedNowTask = LinkedHashMap.fromIterable(
    sortedKeys,
    key: (k) => k,
    value: (k) => dataTaskNow[k],
  );
  return sortedNowTask;
}

// CHOOSE HABITS BY DATE
Map<int, HabitModel?> habitByDateChooser(
    Box<dynamic> habitDb, DateTime dateSelect) {
  Map<int, HabitModel> dataHabitNow = <int, HabitModel>{};
  for (var i = 0; i < habitDb.length; i++) {
    HabitModel habitModel = habitDb.getAt(i);
    for (var j = 0; j < habitModel.dayList.length; j++) {
      if (habitModel.dayList[j] == dateSelect.weekday) {
        dataHabitNow[i] = habitModel;
      }
    }
  }

  List sortedKeys = dataHabitNow.keys.toList(growable: false)
    ..sort((k1, k2) => toDouble(dataHabitNow[k1]!.timeOfDay)
        .compareTo(toDouble(dataHabitNow[k2]!.timeOfDay)));

  LinkedHashMap<int, HabitModel?> sortedNowHabit = LinkedHashMap.fromIterable(
    sortedKeys,
    key: (k) => k,
    value: (k) => dataHabitNow[k],
  );
  return sortedNowHabit;
}

// CONVERT ASSETS TO FILE IMAGE
Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}
