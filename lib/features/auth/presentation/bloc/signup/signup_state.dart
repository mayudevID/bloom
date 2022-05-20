part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }
enum SignupType { email, google, fb }

class SignupState extends Equatable {
  final String name;
  final String email;
  final String password;
  final SignupStatus status;
  final SignupType type;
  final bool isHidden;

  const SignupState({
    required this.name,
    required this.email,
    required this.password,
    required this.status,
    required this.type,
    required this.isHidden,
  });

  factory SignupState.initial() {
    return const SignupState(
      name: '',
      email: '',
      password: '',
      status: SignupStatus.initial,
      type: SignupType.email,
      isHidden: false,
    );
  }

  @override
  List<Object> get props => [email, password, status, type];

  SignupState copyWith({
    String? name,
    String? email,
    String? password,
    SignupStatus? status,
    SignupType? type,
    bool? isHidden,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      type: type ?? this.type,
      isHidden: isHidden ?? this.isHidden,
      name: '',
    );
  }
}