import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../authentication/data/models/user_data.dart';
import '../../../../authentication/data/repositories/local_auth_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required LocalUserDataRepository localUserDataRepository,
  })  : _localUserDataRepository = localUserDataRepository,
        super(const UserState()) {
    on<UserRequested>(_userRequested);
  }

  Future<void> _userRequested(
      UserRequested event, Emitter<UserState> emit) async {
    await emit.forEach<UserData>(
      _localUserDataRepository.getUserData(),
      onData: (userData) => state.copyWith(
        status: UserStatus.success,
        userData: userData,
      ),
      onError: (_, __) => state.copyWith(
        status: UserStatus.failure,
      ),
    );
  }

  final LocalUserDataRepository _localUserDataRepository;
}
