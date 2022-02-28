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
  late String photoUrl;

  @HiveField(4)
  late int habitStreak;

  @HiveField(5)
  late int taskCompleted;

  @HiveField(6)
  late double totalFocus;

  @HiveField(7)
  late int missed;

  @HiveField(8)
  late int completed;

  @HiveField(9)
  late int streakLeft;

  @HiveField(10)
  late bool isNewUser;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.photoUrl,
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
    name = user.get('name');
    email = user.get('email');
    photoUrl = user.get('photoUrl');
    habitStreak = stat.get('habitStreak');
    taskCompleted = stat.get('taskCompleted');
    totalFocus = stat.get('totalFocus').toDouble();
    missed = stat.get('missed');
    completed = stat.get('completed');
    streakLeft = stat.get('streakLeft');
    isNewUser = user.get('isNewUser');
  }
}
