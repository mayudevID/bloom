import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final String? photo;

  const User({
    required this.id,
    this.email,
    this.name,
    this.photo,
  });

  static const empty = User(
    id: '',
    email: '',
    name: '',
    photo: '',
  );

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  // ignore: habit
  // TODO: implement props
  List<Object?> get props => [id, email, name, photo];
}
