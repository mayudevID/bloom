import 'dart:io';

import 'package:bloc/bloc.dart';
import '../../../data/models/user_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/local_auth_repository.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {

  EditProfileCubit(
    this._authRepository,
    this._localUserDataRepository,
  ) : super(
          EditProfileState.initial(
            _localUserDataRepository.getUserDataDirect(),
          ),
        );
  final AuthRepository _authRepository;
  final LocalUserDataRepository _localUserDataRepository;

  void changedTempPicture(File file) {
    emit(state.copyWith(
      profilePictureTemp: file,
      isPictureChanged: true,
    ));
  }

  void changedName(String val) {
    emit(state.copyWith(newName: val));
  }

  void saveProfile() async {
    if (state.status == EditProfileStatus.submitting) {
      return;
    }

    emit(state.copyWith(status: EditProfileStatus.submitting));

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      try {
        final result = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 5));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          final oldData = _localUserDataRepository.getUserDataDirect();
          final userId = oldData.userId;
          if (userId == null || userId.isEmpty) {
            emit(
              state.copyWith(
                status: EditProfileStatus.error,
                errorMessage: 'User data is invalid',
              ),
            );
            return;
          }

          String? newUrl;
          if (state.isPictureChanged) {
            final photoURLold = state.initPhoto;
            await _authRepository.deleteProfilePicture(
              photoURLold,
            );
            newUrl = await _authRepository.uploadProfilePicture(
              state.profilePictureTemp,
              userId,
            );
            await _authRepository.updatePhoto(newUrl);
            CachedNetworkImage.evictFromCache(photoURLold);
          }
          if (state.newName != state.initName) {
            await _authRepository.updateName(state.newName);
          }
          final newUserData = UserData(
            userId: oldData.userId,
            email: oldData.email,
            photoURL: (state.isPictureChanged) ? newUrl : oldData.photoURL,
            name: (state.newName != state.initName)
                ? state.newName
                : oldData.name,
            habitStreak: oldData.habitStreak,
            taskCompleted: oldData.taskCompleted,
            totalFocus: oldData.totalFocus,
            missed: oldData.missed,
            completed: oldData.completed,
            streakLeft: oldData.streakLeft,
          );
          await _localUserDataRepository.saveUserData(newUserData);
        }
        emit(state.copyWith(status: EditProfileStatus.success));
      } on SocketException catch (e) {
        emit(
          state.copyWith(
            status: EditProfileStatus.error,
            errorMessage: e.message,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          status: EditProfileStatus.error,
          errorMessage: "No Connectivity",
        ),
      );
    }
  }
}
