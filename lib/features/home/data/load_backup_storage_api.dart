import 'dart:convert';

import 'package:bloom/features/habit/data/models/habit_model.dart';
import 'package:bloom/features/home/data/load_backup_api.dart';
import 'package:bloom/features/pomodoro/data/models/pomodoro_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../todolist/data/models/task_model.dart';

class LoadBackupStorageApi extends LoadBackupApi {
  LoadBackupStorageApi({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore,
        _firebaseAuth = firebaseAuth;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<List<HabitModel>?> getHabitBackup() async {
    final data = await _firebaseFirestore
        .collection('backupData')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();

    if (data.exists) {
      final dataList =
          List<Map>.from(json.decode(data.get('habitsData')) as List)
              .map((jsonMap) =>
                  HabitModel.fromJson(Map<String, dynamic>.from(jsonMap)))
              .toList();

      return dataList;
    } else {
      return null;
    }
  }

  @override
  Future<List<PomodoroModel>?> getPomodoroBackup() async {
    final data = await _firebaseFirestore
        .collection('backupData')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();

    if (data.exists) {
      final dataList =
          List<Map>.from(json.decode(data.get('pomodorosData')) as List)
              .map((jsonMap) =>
                  PomodoroModel.fromJson(Map<String, dynamic>.from(jsonMap)))
              .toList();

      return dataList;
    } else {
      return null;
    }
  }

  @override
  Future<List<TaskModel>?> getTodoBackup() async {
    final data = await _firebaseFirestore
        .collection('backupData')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();

    if (data.exists) {
      final dataList =
          List<Map>.from(json.decode(data.get('todosData')) as List)
              .map((jsonMap) =>
                  TaskModel.fromJson(Map<String, dynamic>.from(jsonMap)))
              .toList();

      return dataList;
    } else {
      return null;
    }
  }
}
