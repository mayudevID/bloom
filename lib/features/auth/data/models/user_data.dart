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
      email: user['email'],
      photoURL: user['photoUrl'],
      name: user['name'],
      habitStreak: stat['habitStreak'],
      taskCompleted: stat['taskCompleted'],
      totalFocus: stat['totalFocus'],
      missed: stat['missed'],
      completed: stat['completed'],
      streakLeft: stat['streakLeft'],
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'],
      email: json['email'],
      photoURL: json['photoUrl'],
      name: json['name'],
      habitStreak: json['habitStreak'],
      taskCompleted: json['taskCompleted'],
      totalFocus: json['totalFocus'],
      missed: json['missed'],
      completed: json['completed'],
      streakLeft: json['streakLeft'],
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
      ];
}
