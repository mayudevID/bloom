import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import '../models/user_data.dart';

class LocalUserDataRepository {
  LocalUserDataRepository({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences {
    _init();
  }

  final SharedPreferences _sharedPreferences;

  static const kUserDataKey = '__userdata_key__';

  final _userStreamController =
      BehaviorSubject<UserData>.seeded(UserData.empty);

  void _init() {
    var userDataJson = _sharedPreferences.getString(kUserDataKey);
    if (userDataJson == null) {
      _userStreamController.add(UserData.empty);
    } else {
      _userStreamController.add(UserData.fromJson(json.decode(userDataJson)));
    }
  }

  Stream<UserData> getUserData() => _userStreamController.asBroadcastStream();
  UserData getUserDataDirect() => UserData.fromJson(
        json.decode(_sharedPreferences.getString(kUserDataKey) ?? ""),
      );

  Future<void> saveUserData(UserData userData) async {
    _userStreamController.add(userData);
    await _sharedPreferences.setString(
      kUserDataKey,
      json.encode(userData.toJson()),
    );
  }

  Future<void> deleteUserData() async {
    await _sharedPreferences.remove(kUserDataKey);
  }
}

// Future<UserData> getUserData() async {
  //   var userDataJson = _sharedPreferences.getString(kUserDataKey);
  //   if (userDataJson == null) {
  //     return UserData.empty;
  //   }
  //   return UserData.fromJson(json.decode(userDataJson));
  // }