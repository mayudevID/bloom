part of 'forgot_password_cubit.dart';

enum SendStatus { initial, submitting, success, error }

class ForgotPasswordState extends Equatable {
  final String email;
  final SendStatus status;
  final String errorMessage;

  const ForgotPasswordState({
    required this.email,
    required this.status,
    required this.errorMessage,
  });

  factory ForgotPasswordState.initial() {
    return const ForgotPasswordState(
      email: '',
      status: SendStatus.initial,
      errorMessage: '',
    );
  }

  @override
  List<Object> get props => [email, status, errorMessage];

  ForgotPasswordState copyWith({
    String? email,
    SendStatus? status,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
