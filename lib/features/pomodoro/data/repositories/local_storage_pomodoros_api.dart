// ignore_for_file: avoid_renaming_method_parameters

import 'dart:convert';

import 'package:bloom/features/pomodoro/data/models/pomodoro_model.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pomodoros_api.dart';

class LocalStoragePomodorosApi extends PomodorosApi {
  LocalStoragePomodorosApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _pomodoroStreamController =
      BehaviorSubject<List<PomodoroModel>>.seeded(const []);

  @visibleForTesting
  static const kPomodorosCollectionKey = '__pomodoros_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final pomodorosJson = _getValue(kPomodorosCollectionKey);
    if (pomodorosJson != null) {
      final pomodoros = List<Map>.from(json.decode(pomodorosJson) as List)
          .map((jsonMap) =>
              PomodoroModel.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _pomodoroStreamController.add(pomodoros);
    } else {
      _pomodoroStreamController.add(const []);
    }
  }

  @override
  Stream<List<PomodoroModel>> getPomodoros() =>
      _pomodoroStreamController.asBroadcastStream();

  @override
  Future<void> savePomodoro(PomodoroModel pomodoroMo) {
    final pomodoros = [..._pomodoroStreamController.value];
    final pomodoroIndex =
        pomodoros.indexWhere((t) => t.pomodoroId == pomodoroMo.pomodoroId);
    if (pomodoroIndex >= 0) {
      pomodoros[pomodoroIndex] = pomodoroMo;
    } else {
      pomodoros.add(pomodoroMo);
    }

    _pomodoroStreamController.add(pomodoros);
    return _setValue(kPomodorosCollectionKey, json.encode(pomodoros));
  }

  @override
  Future<void> deletePomodoro(String id) async {
    final pomodoros = [..._pomodoroStreamController.value];
    // ignore: unrelated_type_equality_checks
    final pomodoroIndex = pomodoros.indexWhere((t) => t.pomodoroId == id);
    if (pomodoroIndex == -1) {
      throw PomodorosNotFoundException();
    } else {
      pomodoros.removeAt(pomodoroIndex);
      _pomodoroStreamController.add(pomodoros);
      return _setValue(kPomodorosCollectionKey, json.encode(pomodoros));
    }
  }

  @override
  Future<int> clearCompleted() {
    // TODO: implement clearCompleted
    throw UnimplementedError();
  }

  @override
  Future<int> completeAll({required bool isCompleted}) {
    // TODO: implement completeAll
    throw UnimplementedError();
  }

  // @override
  // Future<int> clearCompleted() async {
  //   final pomodoros = [..._pomodoroStreamController.value];
  //   final completedPomodorossAmount = pomodoros.where((t) => t.isCompleted).length;
  //   pomodoros.removeWhere((t) => t.isCompleted);
  //   _pomodoroStreamController.add(pomodoros);
  //   await _setValue(kPomodorossCollectionKey, json.encode(pomodoros));
  //   return completedPomodorossAmount;
  // }

  // @override
  // Future<int> completeAll({required bool isCompleted}) async {
  //   final pomodoros = [..._pomodoroStreamController.value];
  //   final changedPomodorossAmount =
  //       pomodoros.where((t) => t.isCompleted != isCompleted).length;
  //   final newPomodoross = [
  //     for (final pomodoro in pomodoros) pomodoro.copyWith(isCompleted: isCompleted)
  //   ];
  //   _pomodoroStreamController.add(newPomodoross);
  //   await _setValue(kPomodorossCollectionKey, json.encode(newPomodoross));
  //   return changedPomodorossAmount;
  // }
}
