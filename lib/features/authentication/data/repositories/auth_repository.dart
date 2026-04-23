// ignore_for_file: depend_on_referenced_packages

import '../../../../core/error/forgot_pass_exception.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/error/login_exception.dart';
import '../../../../core/error/logout_exception.dart';
import '../../../../core/error/signup_exception.dart';
import '../models/user.dart';
import '../models/user_data.dart';

class AuthRepository {
  AuthRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? firebaseStorage,
    GoogleSignIn? googleSignIn,
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  bool _googleSignInInitialized = false;

  var currentUser = User.empty;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      currentUser = user;
      return user;
    });
  }

  Future<UserData> signInByEmail(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final userData = await getUserFromFirestore(authResult.user!.uid);
    return userData;
  }

  Future<UserData> signUpByEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = authResult.user!.uid;
      final userData = UserData(
        userId: uid,
        name: name,
        email: email,
        habitStreak: 0,
        taskCompleted: 0,
        totalFocus: 0,
        missed: 0,
        completed: 0,
        streakLeft: 0,
      );
      await createNewUserForFirestore(userData);
      return userData;
    } on FirebaseException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    }
  }

  Future<UserData> signInSignUpByGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final googleCredential = firebase_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userData = await createOrGet(googleCredential);
      return userData;
    } on FirebaseException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } on PlatformException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _ensureGoogleSignInInitialized();
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on firebase_auth.FirebaseException {
      throw LogOutFailure();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      throw SendEmailFailure.fromCode(e.code);
    }
  }

  //* ------------------ FIREBASE ------------------

  Future<UserData> getUserFromFirestore(String uid) async {
    try {
      final user = await _firestore.collection("users").doc(uid).get();
      final stat = await _firestore.collection("stats").doc(uid).get();
      return UserData.fromDocumentSnapshot(user, stat);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<void> createNewUserForFirestore(UserData user) async {
    try {
      final userId = user.userId;
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID is empty.');
      }

      await _firestore.collection('users').doc(userId).set(
        {
          "name": user.name,
          "email": user.email,
        },
      );
      await _firestore.collection('stats').doc(userId).set(
        {
          "habitStreak": user.habitStreak,
          "taskCompleted": user.taskCompleted,
          "totalFocus": user.totalFocus,
          "missed": user.missed,
          "completed": user.completed,
          "streakLeft": user.streakLeft,
        },
      );
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateName(String name) async {
    await _firestore.collection('users').doc(_getCurrentUid()).update(
      {
        "name": name,
      },
    );
  }

  Future<void> updatePhoto(String url) async {
    await _firestore.collection('users').doc(_getCurrentUid()).update(
      {
        "photoUrl": url,
      },
    );
  }

  Future<UserData> createOrGet(
    firebase_auth.OAuthCredential oAuthCredential,
  ) async {
    try {
      final authResult =
          await _firebaseAuth.signInWithCredential(oAuthCredential);
      final uid = authResult.user!.uid;

      if (authResult.additionalUserInfo!.isNewUser) {
        //final photoDefault = await getImageFileFromAssets('icons/profpict.png');

        DefaultCacheManager()
          ..emptyCache()
          ..dispose();

        final userData = UserData(
          userId: uid,
          name: authResult.user!.displayName,
          email: authResult.user!.email ?? '',
          habitStreak: 0,
          taskCompleted: 0,
          totalFocus: 0,
          missed: 0,
          completed: 0,
          streakLeft: 0,
        );
        await createNewUserForFirestore(userData);
        return userData;
      } else {
        final userData = await getUserFromFirestore(uid);
        return userData;
      }
    } on PlatformException catch (e) {
      throw PlatformException(code: e.code);
    }
  }

  String _getCurrentUid() {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw Exception('No authenticated user found.');
    }
    return uid;
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) {
      return;
    }

    await _googleSignIn.initialize();
    _googleSignInInitialized = true;
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(
      id: uid,
      name: displayName,
      email: email,
      photo: photoURL,
    );
  }
}
