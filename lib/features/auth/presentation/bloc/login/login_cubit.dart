import 'package:bloc/bloc.dart';
import 'package:bloom/core/error/login_exception.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/local_auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final LocalUserDataRepository _localUserDataRepository;

  LoginCubit(
    this._authRepository,
    this._localUserDataRepository,
  ) : super(LoginState.initial());

  void hidePassword() {
    emit(state.copyWith(
      isHidden: !state.isHidden,
      status: LoginStatus.initial,
    ));
  }

  void emailChanged(String value) {
    emit(state.copyWith(
      email: value,
      status: LoginStatus.initial,
      type: LoginType.email,
    ));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(
      password: value,
      status: LoginStatus.initial,
      type: LoginType.email,
    ));
  }

  void loginWithCredentials(LoginType type) async {
    if (state.status == LoginStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: LoginStatus.initial));
    emit(state.copyWith(status: LoginStatus.submitting, type: type));
    try {
      if (type == LoginType.email) {
        final userData = await _authRepository.signInByEmail(
          state.email,
          state.password,
        );
        await _localUserDataRepository.saveUserData(userData);
        emit(state.copyWith(status: LoginStatus.success));
      } else if (type == LoginType.google) {
        final userData = await _authRepository.signInSignUpByGoogle();
        await _localUserDataRepository.saveUserData(userData);
        emit(state.copyWith(status: LoginStatus.success));
      } else {
        final userData = await _authRepository.signInSignUpByFacebook();
        await _localUserDataRepository.saveUserData(userData);
        emit(state.copyWith(status: LoginStatus.success));
      }
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(status: LoginStatus.error, errorMessage: e.message));
    } on LogInWithGoogleFailure catch (e) {
      emit(state.copyWith(status: LoginStatus.error, errorMessage: e.message));
    }
  }
}
