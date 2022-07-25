import 'package:bloom/features/settings/data/settings_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseDatabaseApi extends SettingsApi {
  FirebaseDatabaseApi({
    required SharedPreferences plugin,
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth firebaseAuth,
  })  : _plugin = plugin,
        _firebaseFirestore = firebaseFirestore,
        _firebaseAuth = firebaseAuth;

  final SharedPreferences _plugin;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;

  static const kPomodorosCollectionKey = '__pomodoros_collection_key__';
  static const kHabitsCollectionKey = '__habits_collection_key__';
  static const kTodosCollectionKey = '__todos_collection_key__';

  @override
  Future<void> backupData() async {
    // ignore: todo
    // TODO: implement backupData
    final pomodoros = _plugin.getString(kPomodorosCollectionKey);
    final habits = _plugin.getString(kHabitsCollectionKey);
    final todos = _plugin.getString(kTodosCollectionKey);

    await _firebaseFirestore
        .collection('backupData')
        .doc(_firebaseAuth.currentUser!.uid)
        .set(
      {
        'pomodorosData': pomodoros,
        'habitsData': habits,
        'todosData': todos,
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
  }
}
