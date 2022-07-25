part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

enum LoginType { email, google, fb }

enum LoadStatus { initial, opening, closing }

class LoginState extends Equatable {
  final String email;
  final String password;
  final LoginStatus status;
  final LoadStatus loadStatus;
  final LoginType type;
  final bool isHidden;
  final String errorMessage;

  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    required this.loadStatus,
    required this.type,
    required this.isHidden,
    required this.errorMessage,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      status: LoginStatus.initial,
      loadStatus: LoadStatus.initial,
      type: LoginType.email,
      isHidden: true,
      errorMessage: '',
    );
  }

  @override
  List<Object> get props => [
        email,
        password,
        status,
        loadStatus,
        type,
        isHidden,
        errorMessage,
      ];

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    LoadStatus? loadStatus,
    LoginType? type,
    bool? isHidden,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      loadStatus: loadStatus ?? this.loadStatus,
      type: type ?? this.type,
      isHidden: isHidden ?? this.isHidden,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
