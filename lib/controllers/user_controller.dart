// ignore_for_file: prefer_final_fields

import 'package:bloom/models/user.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class UserController extends GetxController {
  Rx<UserModel> userModel = UserModel(
    userId: "0",
    name: "user",
    email: "user@user.com",
    habitStreak: 0,
    taskCompleted: 0,
    totalFocus: 0,
    missed: 0,
    completed: 0,
    streakLeft: 0,
  ).obs;

  @override
  void onInit() async {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    var userData = await Hive.openBox('user_data');
    userModel.value = userData.get('user') ?? userModel.value;
  }

  Future<void> setUser(UserModel newUserModel) async {
    userModel.value = newUserModel;
    var userData = await Hive.openBox('user_data');
    await userData.put('user', newUserModel);
  }

  Future<void> clear() async {
    userModel.value = UserModel(
      userId: "0",
      name: "user",
      email: "user@user.com",
      habitStreak: 0,
      taskCompleted: 0,
      totalFocus: 0,
      missed: 0,
      completed: 0,
      streakLeft: 0,
    );
    var userData = await Hive.openBox('user_data');
    await userData.delete('user');
  }

  Future<void> updateData(String type, bool value) async {
    UserModel newUserModel = UserModel(
      userId: userModel.value.userId,
      name: userModel.value.name,
      email: userModel.value.email,
      habitStreak: (type == 'habitStreak')
          ? ((value == true)
              ? userModel.value.habitStreak + 1
              : userModel.value.habitStreak - 1)
          : userModel.value.habitStreak,
      taskCompleted: (type == 'taskCompleted')
          ? ((value == true)
              ? userModel.value.taskCompleted + 1
              : userModel.value.taskCompleted - 1)
          : userModel.value.taskCompleted,
      totalFocus: userModel.value.totalFocus,
      missed: userModel.value.missed,
      completed: userModel.value.completed,
      streakLeft: userModel.value.streakLeft,
    );
    await setUser(newUserModel);
  }
}
