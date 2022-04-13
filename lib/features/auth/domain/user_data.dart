// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  final String? userId;
  final int habitStreak;
  final int taskCompleted;
  final double totalFocus;
  final int missed;
  final int completed;
  final int streakLeft;
  final bool isNewUser;

  const UserData({
    required this.userId,
    required this.habitStreak,
    required this.taskCompleted,
    required this.totalFocus,
    required this.missed,
    required this.completed,
    required this.streakLeft,
    required this.isNewUser,
  });

  bool get isEmpty => this == UserData.empty;
  bool get isNotEmpty => this != UserData.empty;

  static const empty = UserData(
    userId: null,
    habitStreak: 0,
    taskCompleted: 0,
    totalFocus: 0,
    missed: 0,
    completed: 0,
    streakLeft: 0,
    isNewUser: false,
  );

  factory UserData.fromDocumentSnapshot(
    DocumentSnapshot user,
    DocumentSnapshot stat,
  ) {
    return UserData(
      userId: user.id,
      habitStreak: stat['habitStreak'] as int,
      taskCompleted: stat['taskCompleted'] as int,
      totalFocus: stat['totalFocus'] as double,
      missed: stat['missed'] as int,
      completed: stat['completed'] as int,
      streakLeft: stat['streakLeft'] as int,
      isNewUser: stat['isNewUser'] as bool,
    );
  }

  @override
  // ignore: habit
  // TODO: implement props
  List<Object?> get props => [
        userId,
        habitStreak,
        taskCompleted,
        totalFocus,
        missed,
        completed,
        streakLeft,
        isNewUser,
      ];
}
