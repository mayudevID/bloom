import 'package:bloc/bloc.dart';
import 'package:bloom/features/auth/data/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginState.initial());

  void hidePassword() {
    emit(state.copyWith(isHidden: !state.isHidden));
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
    emit(state.copyWith(status: LoginStatus.submitting, type: type));
    try {
      if (type == LoginType.email) {
        await _authRepository.signInByEmail(state.email, state.password);
        emit(state.copyWith(status: LoginStatus.success));
      } else if (type == LoginType.google) {
        await _authRepository.signInSignUpByGoogle();
        emit(state.copyWith(status: LoginStatus.success));
      } else {
        await _authRepository.signInSignUpByFacebook();
        emit(state.copyWith(status: LoginStatus.success));
      }
    } on FirebaseException catch (e) {}
  }
}
