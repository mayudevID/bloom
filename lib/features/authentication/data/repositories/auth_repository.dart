// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:bloom/core/error/forgot_pass_exception.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as path_package;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/error/login_exception.dart';
import '../../../../core/error/logout_exception.dart';
import '../../../../core/error/signup_exception.dart';
import '../../../../core/utils/function.dart';
import '../models/user.dart';
import '../models/user_data.dart';

class AuthRepository {
  AuthRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? firebaseStorage,
    FacebookAuth? facebookAuth,
    GoogleSignIn? googleSignIn,
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _firestore = firestore ?? FirebaseFirestore.instance,
        _facebookAuth = facebookAuth ?? FacebookAuth.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;
  final FacebookAuth _facebookAuth;
  final GoogleSignIn _googleSignIn;

  var currentUser = User.empty;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      var user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      currentUser = user;
      return user;
    });
  }

  Future<UserData> signInByEmail(String email, String password) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final userData = await getUserFromFirestore(authResult.user!.uid);
      return userData;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    }
  }

  Future<UserData> signUpByEmail(
      String name, String email, String password) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final photoDefault = await getImageFileFromAssets('icons/profpict.png');
      final photoURL = await uploadProfilePicture(photoDefault);
      final userData = UserData(
        userId: authResult.user!.uid,
        name: name,
        email: email,
        photoURL: photoURL,
        habitStreak: 0,
        taskCompleted: 0,
        totalFocus: 0,
        missed: 0,
        completed: 0,
        streakLeft: 0,
      );
      await createNewUserForFirestore(userData);
      return userData;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    }
  }

  Future<UserData> signInSignUpByFacebook() async {
    try {
      final LoginResult loginResult = await _facebookAuth.login();

      final firebase_auth.OAuthCredential facebookAuthCredential =
          firebase_auth.FacebookAuthProvider.credential(
              loginResult.accessToken!.token);

      //var credentialSave = await Hive.openBox('credentialSave');
      //await credentialSave.put('token', loginResult.accessToken!.token);
      //credentialSave.close();

      final userData = await createOrGet(facebookAuthCredential);
      return userData;
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  Future<UserData> signInSignUpByGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final googleCredential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userData = await createOrGet(googleCredential);
        return userData;
      } else {
        throw const LogInWithGoogleFailure("Google Sign-in cancelled");
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } on PlatformException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        GoogleSignIn().signOut(),
        //_facebookAuth.logOut()
      ]);
    } on firebase_auth.FirebaseAuthException {
      throw LogOutFailure();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      final providerList =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);
      if (kDebugMode) print(providerList);
      // if (providerList.contains('password')) {
      //   await _auth.sendPasswordResetEmail(email: email);
      // } else {
      // Get.snackbar(
      //   "Account not listed",
      //   "Email is linked to Google Account/Facebook, not password",
      //   colorText: naturalWhite,
      //   snackPosition: SnackPosition.BOTTOM,
      //   margin: const EdgeInsets.only(
      //     bottom: 80,
      //     left: 30,
      //     right: 30,
      //   ),
      //   backgroundColor: naturalBlack,
      //   animationDuration: const Duration(milliseconds: 100),
      //   forwardAnimationCurve: Curves.fastOutSlowIn,
      //   reverseAnimationCurve: Curves.fastOutSlowIn,
      // );
      // }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SendEmailFailure.fromCode(e.code);
    }
  }

  //* ------------------ FIREBASE ------------------

  Future<UserData> getUserFromFirestore(String uid) async {
    try {
      DocumentSnapshot user =
          await _firestore.collection("users").doc(uid).get();
      DocumentSnapshot stat =
          await _firestore.collection("stats").doc(uid).get();
      return UserData.fromDocumentSnapshot(user, stat);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<void> createNewUserForFirestore(UserData user) async {
    try {
      await _firestore.collection('users').doc(currentUser.id).set(
        {
          "name": user.name,
          "email": user.email,
          "photoUrl": user.photoURL,
        },
      );
      await _firestore.collection('stats').doc(currentUser.id).set(
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

  Future<String> uploadProfilePicture(File? fileData) async {
    if (fileData != null) {
      var pathOld = fileData.path;
      var lastSeparator = pathOld.lastIndexOf(Platform.pathSeparator);
      var newPath = pathOld.substring(0, lastSeparator + 1) + currentUser.id;
      final newFileData = await fileData.rename(newPath);
      String path = path_package.basename(newFileData.path);
      final ref = _firebaseStorage.ref('profilePicture/$path');
      UploadTask uploadTask = ref.putFile(newFileData);
      final snapshotData = await uploadTask.whenComplete(() {});
      final photoDownload = snapshotData.ref.getDownloadURL();
      return photoDownload;
    } else {
      return "Empty";
    }
  }

  Future<void> deleteProfilePicture(String photoURL) async {
    await _firebaseStorage.refFromURL(photoURL).delete();
  }

  Future<void> updateName(String name) async {
    await _firestore.collection('users').doc(currentUser.id).update(
      {
        "name": name,
      },
    );
  }

  Future<void> updatePhoto(String url) async {
    await _firestore.collection('users').doc(currentUser.id).update(
      {
        "photoUrl": url,
      },
    );
  }

  Future<UserData> createOrGet(
      firebase_auth.OAuthCredential oAuthCredential) async {
    try {
      var authResult =
          await _firebaseAuth.signInWithCredential(oAuthCredential);

      if (authResult.additionalUserInfo!.isNewUser) {
        final File photoDefault;

        if (authResult.user!.photoURL != null) {
          photoDefault = await DefaultCacheManager()
              .getSingleFile(authResult.user!.photoURL as String);
        } else {
          photoDefault = await getImageFileFromAssets('icons/profpict.png');
        }

        final photoURL = await uploadProfilePicture(photoDefault);
        DefaultCacheManager()
          ..emptyCache()
          ..dispose();

        final userData = UserData(
          userId: authResult.user!.uid,
          name: authResult.user!.displayName,
          email: authResult.user!.email as String,
          photoURL: photoURL,
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
        final userData = await getUserFromFirestore(authResult.user!.uid);
        return userData;
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } on PlatformException catch (e) {
      throw PlatformException(code: e.code);
    }
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
