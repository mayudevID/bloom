part of 'forgot_password_cubit.dart';

enum SendStatus { initial, submitting, success, error }

class ForgotPasswordState extends Equatable {
  final String email;
  final SendStatus status;

  const ForgotPasswordState({required this.email, required this.status});

  factory ForgotPasswordState.initial() {
    return const ForgotPasswordState(
      email: '',
      status: SendStatus.initial,
    );
  }

  @override
  List<Object> get props => [email, status];

  ForgotPasswordState copyWith({String? email, SendStatus? status}) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }
}
