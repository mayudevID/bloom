import 'package:bloom/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.userId).set({
        "name": user.name,
        "email": user.email,
        "habitStreak": user.habitStreak,
        "taskCompleted": user.taskCompleted,
        "totalFocus": user.totalFocus,
        "missed": user.missed,
        "completed": user.completed,
        "streakLeft": user.streakLeft,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection("users").doc(uid).get();
      return UserModel.fromDocumentSnapshot(doc);
    } catch (e) {
      rethrow;
    }
  }
}
