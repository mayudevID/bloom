import 'dart:io';
import 'package:bloom/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_local_db.dart';

class FirebaseDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.userId).set({
        "name": user.name,
        "email": user.email,
        "photoUrl": user.photoUrl,
        "isNewUser": user.isNewUser,
      });
      await _firestore.collection('stats').doc(user.userId).set({
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
      DocumentSnapshot user =
          await _firestore.collection("users").doc(uid).get();
      DocumentSnapshot stat =
          await _firestore.collection("stats").doc(uid).get();
      print(user.data());
      print(stat.data());
      return UserModel.fromDocumentSnapshot(user, stat);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadProfilePicture(File? fileData) async {
    if (fileData != null) {
      String path = basename(fileData.path);
      String photoLoc = 'profilePicture/$path';
      final ref = _storage.ref(photoLoc);
      UploadTask uploadTask = ref.putFile(fileData);
      final snapshotData = await uploadTask.whenComplete(() {});
      final photoDownload = snapshotData.ref.getDownloadURL();
      return photoDownload;
    } else {
      return Get.find<AuthController>().userAuth!.photoURL as String;
    }
  }

  Future<void> deleteProfilePicture() async {
    String photoURL = Get.find<UserController>().userModel.value.photoUrl;
    await FirebaseStorage.instance.refFromURL(photoURL).delete();
  }
}
