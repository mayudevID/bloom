import 'package:bloc/bloc.dart';
import 'package:bloom/features/habit/data/models/habit_model.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repositories/habit_repository.dart';

part 'habits_overview_event.dart';
part 'habits_overview_state.dart';

class HabitsOverviewBloc
    extends Bloc<HabitsOverviewEvent, HabitsOverviewState> {
  HabitsOverviewBloc({
    required HabitsRepository habitsRepository,
  })  : _habitsRepository = habitsRepository,
        super(HabitsOverviewState()) {
    on<HabitsOverviewSubscriptionRequested>(_onSubscriptionRequested);
    //on<HabitsOverviewHabitCompletionToggled>(_onHabitCompletionToggled);
    on<HabitsOverviewHabitDeleted>(_onHabitDeleted);
    on<HabitsOverviewUndoDeletionRequested>(_onUndoDeletionRequested);
    on<HabitsOverviewFilterChanged>(_onFilterChanged);
    //on<HabitsOverviewToggleAllRequested>(_onToggleAllRequested);
    //on<HabitsOverviewClearCompletedRequested>(_onClearCompletedRequested);
  }

  final HabitsRepository _habitsRepository;

  Future<void> _onSubscriptionRequested(
    HabitsOverviewSubscriptionRequested event,
    Emitter<HabitsOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => HabitsOverviewStatus.loading));

    await emit.forEach<List<HabitModel>>(
      _habitsRepository.getHabits(),
      onData: (habits) => state.copyWith(
        status: () => HabitsOverviewStatus.success,
        habits: () => habits,
      ),
      onError: (_, __) => state.copyWith(
        status: () => HabitsOverviewStatus.failure,
      ),
    );
  }

  // Future<void> _onHabitCompletionToggled(
  //   HabitsOverviewHabitCompletionToggled event,
  //   Emitter<HabitsOverviewState> emit,
  // ) async {
  //   final newHabit = event.habit.copyWith(isCompleted: event.isCompleted);
  //   await _habitsRepository.saveHabit(newHabit);
  // }

  Future<void> _onHabitDeleted(
    HabitsOverviewHabitDeleted event,
    Emitter<HabitsOverviewState> emit,
  ) async {
    emit(state.copyWith(lastDeletedHabit: () => event.habit));
    await _habitsRepository.deleteHabits(event.habit.habitId.toString());
  }

  Future<void> _onUndoDeletionRequested(
    HabitsOverviewUndoDeletionRequested event,
    Emitter<HabitsOverviewState> emit,
  ) async {
    assert(
      state.lastDeletedHabit != null,
      'Last deleted habit can not be null.',
    );

    final habit = state.lastDeletedHabit!;
    emit(state.copyWith(lastDeletedHabit: () => null));
    await _habitsRepository.saveHabits(habit);
  }

  void _onFilterChanged(
    HabitsOverviewFilterChanged event,
    Emitter<HabitsOverviewState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }

  // Future<void> _onToggleAllRequested(
  //   HabitsOverviewToggleAllRequested event,
  //   Emitter<HabitsOverviewState> emit,
  // ) async {
  //   final areAllCompleted = state.habits.every((habit) => habit.isCompleted);
  //   await _habitsRepository.completeAll(isCompleted: !areAllCompleted);
  // }

  // Future<void> _onClearCompletedRequested(
  //   HabitsOverviewClearCompletedRequested event,
  //   Emitter<HabitsOverviewState> emit,
  // ) async {
  //   await _habitsRepository.clearCompleted();
  // }
}
