import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  late String userId;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String email;

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
  });

  UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    userId = doc.id;
    name = doc['name'];
    email = doc['email'];
    habitStreak = doc['habitStreak'];
    taskCompleted = doc['taskCompleted'];
    totalFocus = doc['totalFocus'];
    missed = doc['missed'];
    completed = doc['completed'];
    streakLeft = doc['streakLeft'];
  }
}
