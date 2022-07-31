import 'package:bloc/bloc.dart';
import 'package:bloom/core/error/forgot_pass_exception.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/auth_repository.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(ForgotPasswordState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SendStatus.initial));
  }

  Future<void> sendRequestForgotPassword() async {
    if (state.status == SendStatus.submitting) return;

    emit(state.copyWith(status: SendStatus.submitting));
    try {
      await _authRepository.resetPassword(state.email);
      emit(state.copyWith(status: SendStatus.success));
    } on SendEmailFailure catch (e) {
      emit(state.copyWith(
        status: SendStatus.error,
        errorMessage: e.message,
      ));
    }
  }
}
