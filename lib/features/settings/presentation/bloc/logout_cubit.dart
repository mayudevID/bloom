import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../auth/data/auth_repository.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRepository _authRepository;

  LogoutCubit(this._authRepository) : super(LogoutState.initial());

  void logOut() async {
    if (state.status == LogoutStatus.processing) {
      return;
    }
    emit(state.copyWith(status: LogoutStatus.processing));
    try {
      await _authRepository.signOut();
      emit(state.copyWith(status: LogoutStatus.success));
    } catch (e) {}
  }
}
