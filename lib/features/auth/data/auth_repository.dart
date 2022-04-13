// ignore_for_file: constant_identifier_names
import 'package:bloom/core/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../domain/user.dart';
import '../domain/user_data.dart';
import 'auth_local_data.dart';

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  //final FirebaseStorage _storage = FirebaseStorage.instance;

  AuthRepository({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  var currentUser = User.empty;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      var user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      currentUser = user as User;
      return user;
    });
  }

  Future<UserData> signInByEmail(String email, String password) async {
    try {
      var _authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      UserData userData = await getUserFromFirestore(_authResult.user!.uid);
      //await localDataSource.saveData(userData);
      return userData;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<UserData> signUpByEmail(
      String name, String email, String password) async {
    try {
      var _authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      // File photoDefault = await getImageFileFromAssets('icons/profpict.png');
      // String photoURL = await firebaseDb.uploadProfilePicture(photoDefault);
      UserData userData = getNewDataModel(_authResult);
      await createNewUserForFirestore(userData);
      //await localDataSource.saveData(userData);
      return userData;
    } on Exception catch (e) {
      throw Exception(e);
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

      UserData userData = await createOrGet(facebookAuthCredential);
      return userData;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<UserData> signInSignUpByGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ['email']).signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final googleCredential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserData userData = await createOrGet(googleCredential);
      return userData;
    } on Exception catch (e) {
      // ignore: habit
      // TODO
      throw Exception(e);
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        GoogleSignIn().signOut(),
        _facebookAuth.logOut()
      ]);
      // var taskDb = await Hive.openBox(TASK_DB);
      // var habitDb = await Hive.openBox(HABIT_DB);
      // var pomodoroDb = await Hive.openBox(POMODORO_DB);
      // var taskHistoryDb = await Hive.openBox(TASK_HISTORY_DB);
      // taskDb.clear();
      // habitDb.clear();
      // pomodoroDb.clear();
      // taskHistoryDb.clear();
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      var providerList = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      print(providerList);
      // if (providerList.contains('password')) {
      //   await _auth.sendPasswordResetEmail(email: email);
      // } else {
      //   Get.snackbar(
      //     "Account not listed",
      //     "Email is linked to Google Account/Facebook, not password",
      //     colorText: naturalWhite,
      //     snackPosition: SnackPosition.BOTTOM,
      //     margin: const EdgeInsets.only(
      //       bottom: 80,
      //       left: 30,
      //       right: 30,
      //     ),
      //     backgroundColor: naturalBlack,
      //     animationDuration: const Duration(milliseconds: 100),
      //     forwardAnimationCurve: Curves.fastOutSlowIn,
      //     reverseAnimationCurve: Curves.fastOutSlowIn,
      //   );
      // }
    } on FirebaseException catch (e) {
      throw Exception(e);
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
      await _firestore.collection('stats').doc(user.userId).set({
        "habitStreak": user.habitStreak,
        "taskCompleted": user.taskCompleted,
        "totalFocus": user.totalFocus,
        "missed": user.missed,
        "completed": user.completed,
        "streakLeft": user.streakLeft,
        "isNewUser": user.isNewUser,
      });
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  // Future<String> uploadProfilePicture(File? fileData) async {
  //   if (fileData != null) {
  //     String path = basename(fileData.path);
  //     String photoLoc = 'profilePicture/$path';
  //     final ref = _storage.ref(photoLoc);
  //     UploadTask uploadTask = ref.putFile(fileData);
  //     final snapshotData = await uploadTask.whenComplete(() {});
  //     final photoDownload = snapshotData.ref.getDownloadURL();
  //     return photoDownload;
  //   } else {
  //     return Get.find<AuthController>().userAuth!.photoURL as String;
  //   }
  // }

  // Future<void> deleteProfilePicture() async {
  //   String photoURL = Get.find<UserController>().userModel.value.photoUrl;
  //   await FirebaseStorage.instance.refFromURL(photoURL).delete();
  // }

  Future<UserData> createOrGet(
      firebase_auth.OAuthCredential oAuthCredential) async {
    try {
      var _authResult =
          await _firebaseAuth.signInWithCredential(oAuthCredential);

      if (_authResult.additionalUserInfo!.isNewUser) {
        UserData _userData = getNewDataModel(_authResult);
        await createNewUserForFirestore(_userData);
        //await localDataSource.saveData(_userData);
        return _userData;
      } else {
        UserData user = await getUserFromFirestore(_authResult.user!.uid);
        //await localDataSource.saveData(user);
        return user;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  UserData getNewDataModel(firebase_auth.UserCredential userCredential) {
    return const UserData(
      userId: '',
      habitStreak: 0,
      taskCompleted: 1,
      totalFocus: 0,
      missed: 0,
      completed: 0,
      streakLeft: 0,
      isNewUser: true,
    );
  }
}

extension on firebase_auth.User {
  User toUser() {
    return User(
      id: uid,
      name: displayName,
      email: email,
      photo: photoURL,
    );
  }
}
