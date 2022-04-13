import 'package:bloom/features/auth/domain/user_data.dart';

import '../../../../core/utils/constant.dart';

// class AuthLocalDataSource {
//   late Box userData;

//   void init() async {
//     userData = await Hive.openBox(USER_DB);
//   }

//   Future<void> saveData(UserData user) async {
//     try {
//       var userDb = await Hive.openBox(USER_DB);
//       userDb.put(USER_DB, user);
//     } on Exception catch (e) {
//       // ignore: habit
//       // TODO
//       throw Exception(e);
//     }
//   }

//   Future<UserData> loadData() async {
//     try {
//       var userDb = await Hive.openBox(USER_DB);
//       UserData userData = userDb.get(USER_DB);
//       return userData;
//     } on Exception catch (e) {
//       // ignore: habit
//       // TODO
//       throw Exception(e);
//     }
//   }
// }
