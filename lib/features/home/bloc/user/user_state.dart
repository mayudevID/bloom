part of 'user_bloc.dart';

enum UserStatus { loading, success, failure }

class UserState extends Equatable {
  const UserState({
    this.userData = UserData.empty,
    this.status = UserStatus.loading,
  });

  final UserData userData;
  final UserStatus status;

  // factory UserState.initial() {
  //   return const UserState(
  //     name: '',
  //     email: '',
  //     profilePicture: '',
  //     status: UserStatus.loading,
  //   );
  // }

  UserState copyWith({
    UserData? userData,
    UserStatus? status,
  }) {
    return UserState(
      userData: userData ?? this.userData,
      status: status ?? this.status,
    );
  }

  @override
  // ignore: todo
  // TODO: implement props
  List<Object?> get props => [
        userData,
        status,
      ];
}
