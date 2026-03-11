part of 'edit_profile_cubit.dart';

enum EditProfileStatus { initial, submitting, success, error }

class EditProfileState extends Equatable {
  const EditProfileState({
    required this.status,
    required this.initName,
    required this.newName,
    required this.initEmail,
    required this.errorMessage,
  });

  factory EditProfileState.initial(UserData userData) {
    return EditProfileState(
      initName: userData.name ?? "User",
      initEmail: userData.email,
      newName: userData.name ?? "User",
      status: EditProfileStatus.initial,
      errorMessage: '',
    );
  }
  final String newName;
  final EditProfileStatus status;
  final String initName;
  final String initEmail;
  final String errorMessage;

  EditProfileState copyWith({
    String? newName,
    String? initEmail,
    EditProfileStatus? status,
    String? initName,
    String? errorMessage,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      initName: initName ?? this.initName,
      newName: newName ?? this.newName,
      initEmail: initEmail ?? this.initEmail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        newName,
        status,
        initName,
        initEmail,
        errorMessage,
      ];
}
