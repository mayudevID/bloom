part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }
enum LoginType { email, google, fb }

class LoginState extends Equatable {
  final String email;
  final String password;
  final LoginStatus status;
  final LoginType type;
  final bool isHidden;

  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    required this.type,
    required this.isHidden,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      status: LoginStatus.initial,
      type: LoginType.email,
      isHidden: false,
    );
  }

  @override
  List<Object> get props => [email, password, status, type, isHidden];

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    LoginType? type,
    bool? isHidden,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      type: type ?? this.type,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}