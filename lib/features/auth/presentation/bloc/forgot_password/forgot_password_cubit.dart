import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/auth_repository.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit(this._authRepository)
      : super(ForgotPasswordState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SendStatus.initial));
  }

  Future<void> sendRequestForgotPassword() async {
    if (state.status == SendStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: SendStatus.submitting));
    try {
      //await _authRepository.resetPassword(state.email);
      emit(state.copyWith(status: SendStatus.success));
    } catch (e) {}
  }
}
