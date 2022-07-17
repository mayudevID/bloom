import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../authentication/data/repositories/auth_repository.dart';
import '../../../authentication/data/repositories/local_auth_repository.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRepository _authRepository;
  final LocalUserDataRepository _localUserDataRepository;

  LogoutCubit(
    this._authRepository,
    this._localUserDataRepository,
  ) : super(LogoutState.initial());

  Future<void> logOut() async {
    if (state.status == LogoutStatus.processing) {
      return;
    }
    emit(state.copyWith(status: LogoutStatus.processing));
    try {
      await _authRepository.signOut();
      await _localUserDataRepository.deleteUserData();
      emit(state.copyWith(status: LogoutStatus.success));
    } catch (e) {}
  }
}
