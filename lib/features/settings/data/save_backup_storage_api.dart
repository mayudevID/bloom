import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/data/models/user_data.dart';
import 'save_backup_api.dart';

class SaveBackupStorageApi extends SaveBackupApi {
  SaveBackupStorageApi({
    required SharedPreferences plugin,
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth firebaseAuth,
  })  : _plugin = plugin,
        _firebaseFirestore = firebaseFirestore,
        _firebaseAuth = firebaseAuth;

  final SharedPreferences _plugin;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  final dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  static const kPomodorosCollectionKey = '__pomodoros_collection_key__';
  static const kHabitsCollectionKey = '__habits_collection_key__';
  static const kTodosCollectionKey = '__todos_collection_key__';
  static const kUpdateData = '__update_key__';

  @override
  Future<DateTime> backupData(UserData statData) async {
    final pomodoros = _plugin.getString(kPomodorosCollectionKey);
    final habits = _plugin.getString(kHabitsCollectionKey);
    final todos = _plugin.getString(kTodosCollectionKey);
    final updateAt = DateTime.now();

    await _firebaseFirestore
        .collection('backupData')
        .doc(_firebaseAuth.currentUser!.uid)
        .set(
      {
        'pomodorosData': pomodoros,
        'habitsData': habits,
        'todosData': todos,
        'updatedAt': updateAt.toIso8601String(),
      },
    );

    await _firebaseFirestore
        .collection('stats')
        .doc(_firebaseAuth.currentUser!.uid)
        .set(
      {
        "habitStreak": statData.habitStreak,
        "taskCompleted": statData.taskCompleted,
        "totalFocus": statData.totalFocus,
        "missed": statData.missed,
        "completed": statData.completed,
        "streakLeft": statData.streakLeft,
      },
    );

    await _plugin.setString(kUpdateData, dateFormat.format(updateAt));
    return updateAt;
  }

  @override
  DateTime? getUpdateDate() {
    final stringDate = _plugin.get(kUpdateData);
    return (stringDate != null) ? dateFormat.parse(stringDate as String) : null;
  }

  @override
  Future<void> deleteUpdateDate() {
    return _plugin.remove(kUpdateData);
  }
}
