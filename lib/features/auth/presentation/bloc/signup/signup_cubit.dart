import 'package:bloc/bloc.dart';
import 'package:bloom/features/auth/data/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit(this._authRepository) : super(SignupState.initial());

  void hidePassword() {
    emit(state.copyWith(isHidden: !state.isHidden));
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
        await _authRepository.signUpByEmail(
            state.name, state.email, state.password);
        emit(state.copyWith(status: SignupStatus.success));
      } else if (type == SignupType.google) {
        await _authRepository.signInSignUpByGoogle();
        emit(state.copyWith(status: SignupStatus.success));
      } else {
        await _authRepository.signInSignUpByFacebook();
        emit(state.copyWith(status: SignupStatus.success));
      }
    } catch (e) {}
  }
}
