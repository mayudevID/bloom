// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  final String? userId;
  final String email;
  final String? photoURL;
  final String? name;
  final int habitStreak;
  final int taskCompleted;
  final double totalFocus;
  final int missed;
  final int completed;
  final int streakLeft;
  final bool isNewUser;

  const UserData({
    required this.userId,
    required this.email,
    required this.photoURL,
    required this.name,
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
    email: '',
    name: '',
    photoURL: '',
  );

  factory UserData.fromDocumentSnapshot(
    DocumentSnapshot user,
    DocumentSnapshot stat,
  ) {
    return UserData(
      userId: user.id,
      email: user['email'] as String,
      photoURL: user['photoUrl'] as String,
      name: user['name'] as String,
      habitStreak: stat['habitStreak'] as int,
      taskCompleted: stat['taskCompleted'] as int,
      totalFocus: stat['totalFocus'] as double,
      missed: stat['missed'] as int,
      completed: stat['completed'] as int,
      streakLeft: stat['streakLeft'] as int,
      isNewUser: user['isNewUser'] as bool,
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'] as String,
      email: json['email'] as String,
      photoURL: json['photoUrl'] as String,
      name: json['name'] as String,
      habitStreak: json['habitStreak'] as int,
      taskCompleted: json['taskCompleted'] as int,
      totalFocus: json['totalFocus'] as double,
      missed: json['missed'] as int,
      completed: json['completed'] as int,
      streakLeft: json['streakLeft'] as int,
      isNewUser: json['isNewUser'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'photoUrl': photoURL,
      'name': name,
      'habitStreak': habitStreak,
      'taskCompleted': taskCompleted,
      'totalFocus': totalFocus,
      'missed': missed,
      'completed': completed,
      'streakLeft': streakLeft,
      'isNewUser': isNewUser,
    };
  }

  UserData copyWith({
    String? userId,
    String? email,
    String? photoURL,
    String? name,
    int? habitStreak,
    int? taskCompleted,
    double? totalFocus,
    int? missed,
    int? completed,
    int? streakLeft,
    bool? isNewUser,
  }) {
    return UserData(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      name: name ?? this.name,
      habitStreak: habitStreak ?? this.habitStreak,
      taskCompleted: taskCompleted ?? this.taskCompleted,
      totalFocus: totalFocus ?? this.totalFocus,
      missed: missed ?? this.missed,
      completed: completed ?? this.completed,
      streakLeft: streakLeft ?? this.streakLeft,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }

  @override
  // ignore: habit
  // TODO: implement props
  List<Object?> get props => [
        userId,
        email,
        photoURL,
        name,
        habitStreak,
        taskCompleted,
        totalFocus,
        missed,
        completed,
        streakLeft,
        isNewUser,
      ];
}
