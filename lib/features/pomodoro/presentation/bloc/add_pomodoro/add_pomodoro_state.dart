part of 'add_pomodoro_cubit.dart';

enum AddPomodoroStatus { initial, submitting, success, error }

class AddPomodoroState extends Equatable {
  final String title;
  final int duration;
  final int session;
  final AddPomodoroStatus status;

  const AddPomodoroState({
    required this.title,
    required this.duration,
    required this.session,
    required this.status,
  });

  factory AddPomodoroState.initial() {
    return const AddPomodoroState(
      title: '',
      duration: 25,
      session: 3,
      status: AddPomodoroStatus.initial,
    );
  }

  @override
  List<Object> get props => [title, duration, session];

  AddPomodoroState copyWith({
    String? title,
    int? duration,
    int? session,
    AddPomodoroStatus? status,
  }) {
    return AddPomodoroState(
      title: title ?? this.title,
      duration: duration ?? this.duration,
      session: session ?? this.session,
      status: status ?? this.status,
    );
  }
}
