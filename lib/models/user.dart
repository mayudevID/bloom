import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  String? userId;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  late int habitStreak;

  @HiveField(4)
  late int taskCompleted;

  @HiveField(5)
  late double totalFocus;

  @HiveField(6)
  late int missed;

  @HiveField(7)
  late int completed;

  @HiveField(8)
  late int streakLeft;

  @HiveField(9)
  late bool isNewUser;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.habitStreak,
    required this.taskCompleted,
    required this.totalFocus,
    required this.missed,
    required this.completed,
    required this.streakLeft,
    required this.isNewUser,
  });

  UserModel.fromDocumentSnapshot(DocumentSnapshot user, DocumentSnapshot stat) {
    userId = user.id;
    name = user['name'];
    email = user['email'];
    habitStreak = stat['habitStreak'];
    taskCompleted = stat['taskCompleted'];
    totalFocus = stat['totalFocus'].toDouble();
    missed = stat['missed'];
    completed = stat['completed'];
    streakLeft = stat['streakLeft'];
    isNewUser = user['isNewUser'];
  }
}
