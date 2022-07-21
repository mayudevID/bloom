import 'package:bloc/bloc.dart';
import 'package:bloom/features/authentication/data/repositories/auth_repository.dart';
import 'package:bloom/features/authentication/data/repositories/local_auth_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../authentication/data/models/user_data.dart';

part 'habit_statistic_event.dart';
part 'habit_statistic_state.dart';

class HabitStatisticBloc
    extends Bloc<HabitStatisticEvent, HabitStatisticState> {
  final LocalUserDataRepository _localUserDataRepository;

  HabitStatisticBloc({required LocalUserDataRepository localUserDataRepository})
      : _localUserDataRepository = localUserDataRepository,
        super(HabitStatisticInitial()) {
    on<GetAllStatistic>(_onGetAllStatistic);
  }

  Future<void> _onGetAllStatistic(
    GetAllStatistic event,
    Emitter<HabitStatisticState> emit,
  ) async {
    final userData = await _localUserDataRepository.getUserDataDirect();
    emit(HabitStatisticLoaded(userData));
  }
}
