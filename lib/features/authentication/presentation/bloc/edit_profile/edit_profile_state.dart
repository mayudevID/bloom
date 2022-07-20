part of 'edit_profile_cubit.dart';

enum EditProfileStatus { initial, submitting, success, error }

class EditProfileState extends Equatable {
  final String newName;
  final bool isPictureChanged;
  final EditProfileStatus status;
  final String initPhoto;
  final String initName;
  final String initEmail;
  final File profilePictureTemp;
  final String errorMessage;

  const EditProfileState({
    required this.status,
    required this.initPhoto,
    required this.initName,
    required this.profilePictureTemp,
    required this.newName,
    required this.isPictureChanged,
    required this.initEmail,
    required this.errorMessage,
  });

  factory EditProfileState.initial(UserData userData) {
    return EditProfileState(
      initName: userData.name ?? "User",
      initPhoto: userData.photoURL ?? "NULL",
      initEmail: userData.email,
      newName: userData.name ?? "User",
      isPictureChanged: false,
      status: EditProfileStatus.initial,
      profilePictureTemp: File(''),
      errorMessage: '',
    );
  }

  EditProfileState copyWith({
    String? newName,
    bool? isPictureChanged,
    EditProfileStatus? status,
    String? initPhoto,
    String? initName,
    String? initEmail,
    File? profilePictureTemp,
    String? errorMessage,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      initPhoto: initPhoto ?? this.initPhoto,
      initName: initName ?? this.initName,
      profilePictureTemp: profilePictureTemp ?? this.profilePictureTemp,
      newName: newName ?? this.newName,
      isPictureChanged: isPictureChanged ?? this.isPictureChanged,
      initEmail: initEmail ?? this.initEmail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        newName,
        isPictureChanged,
        status,
        initPhoto,
        initName,
        initEmail,
        profilePictureTemp,
        errorMessage,
      ];
}
