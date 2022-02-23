// ignore_for_file: prefer_final_fields

import 'package:bloom/models/user.dart';
import 'package:hive/hive.dart';

class UserLocalDB {
  Future<void> setUser(UserModel newUserModel) async {
    var userData = await Hive.openBox('user_data');
    await userData.put('user', newUserModel);
    userData.close();
  }

  Future<void> clear() async {
    var userData = await Hive.openBox('user_data');
    await userData.delete('user');
    userData.close();
  }

  Future<void> updateData(String type, Object value) async {
    var userData = await Hive.openBox('user_data');
    UserModel oldUserModel = userData.get('user');
    UserModel newUserModel = UserModel(
      userId: oldUserModel.userId,
      name: oldUserModel.name,
      email: oldUserModel.email,
      habitStreak: (type == 'habitStreak')
          ? ((value as bool == true)
              ? oldUserModel.habitStreak + 1
              : oldUserModel.habitStreak - 1)
          : oldUserModel.habitStreak,
      taskCompleted: (type == 'taskCompleted')
          ? ((value as bool == true)
              ? oldUserModel.taskCompleted + 1
              : oldUserModel.taskCompleted - 1)
          : oldUserModel.taskCompleted,
      totalFocus: (type == 'totalFocus')
          ? oldUserModel.totalFocus + (value as double)
          : oldUserModel.totalFocus,
      missed: oldUserModel.missed,
      completed: oldUserModel.completed,
      streakLeft: (type == 'streakLeft')
          ? oldUserModel.streakLeft + (value as int)
          : oldUserModel.streakLeft,
      isNewUser: oldUserModel.isNewUser,
    );
    await userData.put('user', newUserModel);
    userData.close();
  }
}
