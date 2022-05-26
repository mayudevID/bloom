import 'package:bloc/bloc.dart';
import 'package:bloom/core/error/signup_exception.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/login_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/local_auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  final LocalUserDataRepository _localUserDataRepository;

  SignupCubit(
    this._authRepository,
    this._localUserDataRepository,
  ) : super(SignupState.initial());

  void hidePassword() {
    emit(state.copyWith(
      isHidden: !state.isHidden,
      status: SignupStatus.initial,
    ));
  }

  void nameChanged(String value) {
    emit(state.copyWith(
      name: value,
      status: SignupStatus.initial,
      type: SignupType.email,
    ));
  }

  void emailChanged(String value) {
    emit(state.copyWith(
      email: value,
      status: SignupStatus.initial,
      type: SignupType.email,
    ));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(
      password: value,
      status: SignupStatus.initial,
      type: SignupType.email,
    ));
  }

  Future<void> signupWithCredentials(SignupType type) async {
    if (state.status == SignupStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: SignupStatus.submitting, type: type));
    try {
      if (type == SignupType.email) {
        final userData = await _authRepository.signUpByEmail(
          state.name,
          state.email,
          state.password,
        );
        await _localUserDataRepository.saveUserData(userData);
        emit(state.copyWith(status: SignupStatus.success));
      } else if (type == SignupType.google) {
        final userData = await _authRepository.signInSignUpByGoogle();
        await _localUserDataRepository.saveUserData(userData);
        emit(state.copyWith(status: SignupStatus.success));
      } else {
        final userData = await _authRepository.signInSignUpByFacebook();
        await _localUserDataRepository.saveUserData(userData);
        emit(state.copyWith(status: SignupStatus.success));
      }
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(status: SignupStatus.error, errorMessage: e.message));
    } on LogInWithGoogleFailure catch (e) {
      emit(state.copyWith(status: SignupStatus.error, errorMessage: e.message));
    }
  }
}
